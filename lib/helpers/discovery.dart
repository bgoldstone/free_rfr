import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

Future<List<String>> getLocalIpAddress() async {
  List<String> address = List<String>.empty(growable: true);
  for (var interface in await NetworkInterface.list()) {
    for (var addr in interface.addresses) {
      if (addr.type == InternetAddressType.IPv4) {
        address.add(addr.address);
      }
    }
  }
  return address;
}

Future<List<String>> discoverHosts(int timeout) async {
  List<String> localIps = await getLocalIpAddress();
  List<String> discoveredHosts = List<String>.empty(growable: true);
  if (localIps.isEmpty) {
    debugPrint("Failed to get local IP address");
    return localIps;
  }

  // Extract network prefix from local IP address
  for (String ip in localIps) {
    List<String> ipOctets = ip.split('.');
    String networkPrefix = '${ipOctets.sublist(0, 3).join('.')}.';

    int lastOctet = 0;

    // Loop through possible hosts on the same network
    for (lastOctet = 1; lastOctet <= 254; lastOctet++) {
      String address = networkPrefix + lastOctet.toString();
      debugPrint("Checking IP address: $address");
      try {
        // Create a socket connection with a timeout
        Socket socket = await Socket.connect(address, 3002,
            timeout: Duration(milliseconds: timeout));
        sleep(Duration(milliseconds: timeout));
        await socket.close();
        debugPrint("Connected to $address:8000");
        discoveredHosts.add(address);

        // Attempt reverse lookup to get hostname (optional)
      } on SocketException catch (e) {
        debugPrint("Cannot connect to $address:8000${e.message}");
      }
    }
  }

  return discoveredHosts;
}

Future<List<String>> getHosts() async {
  // Set a timeout value in milliseconds for connection attempts
  int timeout = 10;

  // Discover hosts on the network
  List<String> discoveredHosts = await discoverHosts(timeout);

  if (discoveredHosts.isEmpty) {
    debugPrint("No hosts found on the network");
  } else {
    debugPrint("Discovered hosts:");
    for (String host in discoveredHosts) {
      debugPrint(host);
    }
  }
  return discoveredHosts;
}

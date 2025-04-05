import React, { useEffect } from "react";
import { View, Text } from "react-native";
import * as Linking from "expo-linking";
type DeepLinkEvent = { url: string };

const handleDeepLink = ({ url }: DeepLinkEvent) => {
  const params = new URLSearchParams(url.split("?")[1]);
  const type = params.get("type"); // "text" or "image"
  const data = params.get("data"); // The shared content

  if (type === "text") {
    console.log("Shared text:", data);
  } else if (type === "image") {
    console.log("Shared image URI:", data);
  }
};

const HomeScreen = () => {
  const url = Linking.useURL();
  if (url) {
    const { hostname, path, queryParams } = Linking.parse(url);
    console.log(
      `Linked to app with hostname: ${hostname}, path: ${path} and data: ${JSON.stringify(
        queryParams
      )}`
    );
  }
  return (
    <View>
      <Text>Hello, World!</Text>
    </View>
  );
};

export default HomeScreen;

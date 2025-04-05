import React from "react";
import { View, Text } from "react-native";
import * as Linking from "expo-linking";

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

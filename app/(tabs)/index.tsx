import React, { useEffect } from "react";
import { View, Text, Linking } from "react-native";
import * as IntentLauncher from "expo-intent-launcher";
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
  useEffect(() => {
    // Check if app was opened by a deep link
    Linking.getInitialURL()
      .then((url) => {
        if (url) handleDeepLink({ url });
      })
      .catch(console.error);

    // Listen for incoming links while the app is open
    Linking.addEventListener("url", handleDeepLink);

    return () => {
      Linking.removeAllListeners("url");
    };
  }, []);
  return (
    <View>
      <Text>Hello, World!</Text>
    </View>
  );
};

export default HomeScreen;

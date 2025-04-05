import React from "react";
import { View, Text } from "react-native";
import { useLocalSearchParams } from "expo-router";
const ShareScreen = () => {
  const { type, data } = useLocalSearchParams();

  return (
    <View>
      <Text>Type: {type}</Text>
      <Text>Data: {data}</Text>
    </View>
  );
};

export default ShareScreen;

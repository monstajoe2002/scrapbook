import { Stack } from "expo-router";

export default function RootLayout() {
  return (
    <Stack>
      <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
      <Stack.Screen name="share" options={{ headerTitle: "Save Scrap" }} />
    </Stack>
  );
}

// app/_layout.js
import { Stack } from "expo-router";

export default function Layout() {
  return (
    <Stack
      screenOptions={{
        headerStyle: { backgroundColor: "#001f3f" },
        headerTintColor: "#fff",
        headerTitleAlign: "center",
      }}
    >
      <Stack.Screen
        name="index"
        options={{ title: "Home" }}
      />

      <Stack.Screen
        name="add-item"
        options={{ title: "Add Item" }}
      />
    </Stack>
  );
}
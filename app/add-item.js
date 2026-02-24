// app/add-item.js
import { useRouter } from "expo-router";
import { useState } from "react";
import {
    Alert,
    StyleSheet,
    Text,
    TextInput,
    TouchableOpacity,
    View,
} from "react-native";

export default function AddItemScreen() {
  const router = useRouter();
  const [itemName, setItemName] = useState("");

  const handleAddItem = () => {
    if (!itemName.trim()) {
      Alert.alert("Error", "Please enter an item name");
      return;
    }
    // Here you would normally update your state or database
    Alert.alert("Success", `${itemName} added!`);
    setItemName("");
    router.push("/"); // go back to home
  };

  return (
    <View style={styles.container}>
      <Text style={styles.header}>Add New Item</Text>

      <TextInput
        style={styles.input}
        placeholder="Enter item name"
        placeholderTextColor="#aaa"
        value={itemName}
        onChangeText={setItemName}
      />

      <TouchableOpacity style={styles.button} onPress={handleAddItem}>
        <Text style={styles.buttonText}>Add Item</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#f5f5f5", // light background for add screen
    padding: 20,
    justifyContent: "center",
  },
  header: {
    fontSize: 28,
    fontWeight: "bold",
    color: "#001f3f", // navy blue accent
    marginBottom: 30,
    textAlign: "center",
  },
  input: {
    backgroundColor: "#fff",
    borderRadius: 10,
    paddingHorizontal: 15,
    paddingVertical: 12,
    fontSize: 18,
    marginBottom: 20,
    borderWidth: 1,
    borderColor: "#ccc",
  },
  button: {
    backgroundColor: "#001f3f", // navy blue
    paddingVertical: 15,
    borderRadius: 10,
  },
  buttonText: {
    color: "#fff",
    fontWeight: "bold",
    fontSize: 18,
    textAlign: "center",
  },
});

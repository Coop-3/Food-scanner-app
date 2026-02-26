// app/add-item.js
import * as ImagePicker from "expo-image-picker";
import { useRouter } from "expo-router";
import { useState } from "react";
import {
  Alert,
  Image,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";

export default function AddItem() {
  const router = useRouter();

  const [image, setImage] = useState(null);
  const [itemName, setItemName] = useState("");
  const [expirationDate, setExpirationDate] = useState("");
  const [status, setStatus] = useState("fresh");

  // 📸 Pick from gallery
  const pickImage = async () => {
    const permission = await ImagePicker.requestMediaLibraryPermissionsAsync();
    if (!permission.granted) {
      Alert.alert("Permission required to access gallery");
      return;
    }

    const result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.Images,
      quality: 1,
    });

    if (!result.canceled) {
      setImage(result.assets[0].uri);
    }
  };

  // 📷 Take photo
  const takePhoto = async () => {
    const permission = await ImagePicker.requestCameraPermissionsAsync();
    if (!permission.granted) {
      Alert.alert("Camera permission required");
      return;
    }

    const result = await ImagePicker.launchCameraAsync({
      quality: 1,
    });

    if (!result.canceled) {
      setImage(result.assets[0].uri);
    }
  };

  // 🧠 Basic date validation (accepts common grocery formats)
  const validateDate = (date) => {
    const regex =
      /^(\d{1,2}\/\d{1,2}\/\d{2,4}|\d{4}-\d{2}-\d{2}|\d{1,2}-\d{1,2}-\d{2,4})$/;
    return regex.test(date);
  };

  const handleSave = () => {
    if (!itemName.trim()) {
      Alert.alert("Please enter an item name.");
      return;
    }

    if (!expirationDate.trim()) {
      Alert.alert("Please enter an expiration date.");
      return;
    }

    if (!validateDate(expirationDate)) {
      Alert.alert(
        "Invalid date format.\nUse formats like:\nMM/DD/YYYY\nYYYY-MM-DD\nMM-DD-YYYY",
      );
      return;
    }

    // For now we just go back
    Alert.alert("Item Added Successfully!");
    router.push("/");
  };

  return (
    <ScrollView contentContainerStyle={styles.container}>
      <Text style={styles.header}>Add New Item</Text>

      {/* IMAGE SECTION */}
      <Text style={styles.label}>Item Image</Text>
      {image && <Image source={{ uri: image }} style={styles.image} />}

      <View style={styles.imageButtons}>
        <TouchableOpacity style={styles.smallButton} onPress={pickImage}>
          <Text style={styles.buttonText}>Pick Image</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.smallButton} onPress={takePhoto}>
          <Text style={styles.buttonText}>Take Photo</Text>
        </TouchableOpacity>
      </View>

      {/* ITEM NAME */}
      <Text style={styles.label}>Item Name</Text>
      <TextInput
        style={styles.input}
        placeholder="Enter item name"
        placeholderTextColor="#aaa"
        value={itemName}
        onChangeText={setItemName}
      />

      {/* EXPIRATION DATE */}
      <Text style={styles.label}>Expiration Date</Text>
      <TextInput
        style={styles.input}
        placeholder="MM/DD/YYYY or YYYY-MM-DD"
        placeholderTextColor="#aaa"
        value={expirationDate}
        onChangeText={setExpirationDate}
      />

      {/* STATUS SELECT */}
      <Text style={styles.label}>Expiration Status</Text>
      <View style={styles.statusContainer}>
        {["fresh", "expiring", "expired"].map((option) => (
          <TouchableOpacity
            key={option}
            style={[
              styles.statusButton,
              status === option && styles.activeStatus,
            ]}
            onPress={() => setStatus(option)}
          >
            <Text style={styles.statusText}>{option.toUpperCase()}</Text>
          </TouchableOpacity>
        ))}
      </View>

      {/* SAVE BUTTON */}
      <TouchableOpacity style={styles.saveButton} onPress={handleSave}>
        <Text style={styles.saveButtonText}>Save Item</Text>
      </TouchableOpacity>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flexGrow: 1,
    backgroundColor: "#001f3f",
    padding: 20,
  },
  header: {
    color: "#fff",
    fontSize: 26,
    fontWeight: "bold",
    marginBottom: 20,
  },
  label: {
    color: "#d3d3d3",
    marginBottom: 8,
    marginTop: 15,
    fontWeight: "600",
  },
  input: {
    backgroundColor: "#111",
    padding: 14,
    borderRadius: 12,
    color: "#fff",
  },
  image: {
    width: "100%",
    height: 180,
    borderRadius: 15,
    marginBottom: 10,
  },
  imageButtons: {
    flexDirection: "row",
    justifyContent: "space-between",
  },
  smallButton: {
    backgroundColor: "#0074D9",
    padding: 12,
    borderRadius: 10,
    flex: 1,
    marginHorizontal: 5,
    alignItems: "center",
  },
  buttonText: {
    color: "#fff",
    fontWeight: "bold",
  },
  statusContainer: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginTop: 10,
  },
  statusButton: {
    backgroundColor: "#111",
    padding: 10,
    borderRadius: 20,
    flex: 1,
    marginHorizontal: 5,
    alignItems: "center",
  },
  activeStatus: {
    backgroundColor: "#0074D9",
  },
  statusText: {
    color: "#fff",
    fontSize: 12,
    fontWeight: "bold",
  },
  saveButton: {
    backgroundColor: "#2ECC40",
    padding: 16,
    borderRadius: 30,
    marginTop: 30,
    alignItems: "center",
  },
  saveButtonText: {
    color: "#000",
    fontWeight: "bold",
    fontSize: 16,
  },
});

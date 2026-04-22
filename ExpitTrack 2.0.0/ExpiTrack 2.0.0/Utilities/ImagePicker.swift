// ImagePicker.swift
//
// UIKit bridge that lets SwiftUI present the camera or photo library and return a selected image.
// Added comments explain the purpose of the file and the role of important members.

import SwiftUI
import UIKit

// ImagePicker groups related state and behavior for this feature.
struct ImagePicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss

    // Creates the coordinator object that handles delegate callbacks from UIKit.
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedImage: $selectedImage, dismiss: dismiss)
    }

    // Creates the UIKit image picker controller used by SwiftUI.
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = UIImagePickerController.isSourceTypeAvailable(sourceType) ? sourceType : .photoLibrary
        picker.allowsEditing = false
        return picker
    }

    // Updates the UIKit picker when SwiftUI state changes.
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    // Coordinator groups related state and behavior for this feature.
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding private var selectedImage: UIImage?
        private let dismiss: DismissAction

        // Initializes the type and prepares any starting state the app needs.
        init(selectedImage: Binding<UIImage?>, dismiss: DismissAction) {
            _selectedImage = selectedImage
            self.dismiss = dismiss
        }

        // Performs one focused piece of work for this file.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                selectedImage = image
            }
            dismiss()
        }

        // Performs one focused piece of work for this file.
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss()
        }
    }
}

//
//  classImagePicker.swift
//  ImagePicker
//
//  Created by iMac on 26/04/22.
//

import Foundation
import UIKit
import MBProgressHUD

//MARK:- Imagepicker Delegate Method's
public protocol SystemImagePickerDelegate {
    func selectedImg(img:UIImage?,videoURL:URL?)
    func cancel()
}

public class SystemImagePicker:NSObject{
    
    //MARK:- Varible's
    public static var shared = SystemImagePicker()
    var delegate:SystemImagePickerDelegate?
    
    public enum photoSourceType{
        case photoLibrary
        case savedPhotosAlbum
    }
    
    public func openPicker(sourceType:photoSourceType = .photoLibrary,
                           allowsEditing:Bool=true,
                           tempDelegate:SystemImagePickerDelegate,
                           viewController:UIViewController){
        
        let tempSourceType:UIImagePickerController.SourceType = sourceType == .photoLibrary ? .photoLibrary : .savedPhotosAlbum
        
        if UIImagePickerController.isSourceTypeAvailable(tempSourceType){
            loader(viewController: viewController)
            delegate = tempDelegate
            let picker = UIImagePickerController()
            picker.sourceType = tempSourceType
            picker.allowsEditing = allowsEditing
            picker.delegate = self
            picker.mediaTypes = ["public.image", "public.movie"]
            viewController.present(picker, animated: true){
                self.loader(isStart: false,viewController: viewController)
            }}
    }
    
    public func openCamera(cameraMode:UIImagePickerController.CameraCaptureMode = .photo,
                           allowsEditing:Bool=true,
                           tempDelegate:SystemImagePickerDelegate,
                           viewController:UIViewController){
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            loader(viewController: viewController)
            delegate = tempDelegate
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = allowsEditing
            picker.delegate = self
            picker.mediaTypes = ["public.image", "public.movie"]
            picker.cameraCaptureMode = cameraMode
            viewController.present(picker, animated: true){
                self.loader(isStart: false,viewController: viewController)
            }}
    }
    
    private func loader(isStart:Bool = true,viewController:UIViewController){
        if isStart{
            MBProgressHUD.showAdded(to: viewController.view, animated: true)
        }else{
            MBProgressHUD.hide(for: viewController.view, animated: true)
        }
    }
    
}
 
extension SystemImagePicker : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        var img:UIImage?
        var videoURL:URL?
        
        if info[.mediaType] as? String ?? "" == "public.movie"{
            videoURL = info[.mediaURL] as? URL
        }else{
            img = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage ?? UIImage()
        }
        
        delegate?.selectedImg(img: img,videoURL: videoURL)
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate?.cancel()
        picker.dismiss(animated: true, completion: nil)
    }
}

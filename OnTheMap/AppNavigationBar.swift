//
//  AppNavigationBar.swift
//  OnTheMap
//
//  Created by Oleksandr Iaroshenko on 13.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit

class AppNavigationBar: UINavigationBar {

    // Magic Values
    private struct Defaults {
        static let SignOutSelector: Selector = "signOut:"
    }

    // MARK: - Actions and Outlets

    func signOut(sender: AnyObject) {
        UdacityAPI.client.signOut() { success in
            if success {

            }
        }
    }

    // MARK: - Layout

    func addButtons() {
        let signOutBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Undo, target: self, action: Defaults.SignOutSelector)
        self.items.append(signOutBarButtonItem)

        println("TODO: Add right button (Add User Location)")
    }
}

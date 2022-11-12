//
//  SwiftUINavigatorTests.swift
//  SwiftUINavigatorTests
//
//  Created by Shaban Kamel on 06/01/2022.
//

import XCTest
import SwiftUI
@testable import SwiftUINavigator

class NavManagerTests: XCTestCase {
    var sheetManager = SheetManager()
    var actionSheetManager = ActionSheetManager()
    var confirmationDialogManager = ConfirmationDialogManager()
    var alertManager = AlertManager()
    var dialogManager = DialogManager()
    var manager: NavManager!

    override func setUpWithError() throws {
        sheetManager = SheetManager()
        actionSheetManager = ActionSheetManager()
        confirmationDialogManager = ConfirmationDialogManager()
        alertManager = AlertManager()
        dialogManager = DialogManager()

        let root = NavManager(
                root: nil,
                easeAnimation: .easeIn,
                showDefaultNavBar: true,
                transition: .default,
                sheetManager: sheetManager,
                actionSheetManager: actionSheetManager,
                confirmationDialogManager: confirmationDialogManager,
                alertManager: alertManager,
                dialogManager: dialogManager
        )
        manager = NavManager(
                root: root,
                easeAnimation: .easeIn,
                showDefaultNavBar: true,
                transition: .default,
                sheetManager: sheetManager,
                actionSheetManager: actionSheetManager,
                confirmationDialogManager: confirmationDialogManager,
                alertManager: alertManager,
                dialogManager: dialogManager
        )
        sheetManager.navManager = manager
    }

    func testNavigate_push_stackItemsShouldBeNotEmpty() throws {
        manager.navigate(
                EmptyView(),
                type: .push(),
                onDismissSheet: {})
        XCTAssertFalse(manager.stackItems.isEmpty)
    }

    func testNavigate_sheet_normal_shouldBePresented() throws {
        manager.navigate(
                EmptyView(),
                type: .sheet(type: .normal),
                onDismissSheet: {})
        XCTAssertTrue(sheetManager.presentSheet)
    }

    func testNavigate_sheet_full_shouldBePresented() throws {
        manager.navigate(
                EmptyView(),
                type: .sheet(type: .full),
                onDismissSheet: {})
        XCTAssertTrue(sheetManager.presentFullSheet)
    }

    func testNavigate_sheet_fixedHeight_shouldBePresented() throws {
        manager.navigate(
                EmptyView(),
                type: .sheet(type: .fixedHeight(.value(0))),
                onDismissSheet: {})
        XCTAssertTrue(sheetManager.presentFixedHeightSheet)
    }

    func testNavigate_dialog_shouldBePresented() throws {
        manager.navigate(
                EmptyView(),
                type: .dialog(),
                onDismissSheet: {})
        XCTAssertTrue(dialogManager.isPresented)
    }

    func testPresentSheet() throws {
        manager.presentSheet(
                type: .normal,
                onDismiss: {}) {
            EmptyView()
        }
        XCTAssertTrue(sheetManager.presentSheet)
    }

    func testPush() throws {
        manager.push(
                EmptyView(),
                withId: nil,
                addToBackStack: true,
                showDefaultNavBar: true)
        XCTAssertFalse(manager.stackItems.isEmpty)
    }

    func testPresentConfirmationDialog() throws {
        manager.presentConfirmationDialog(
                titleKey: "",
                titleVisibility: .automatic,
                content: EmptyView().eraseToAnyView())
        XCTAssertTrue(confirmationDialogManager.isPresented)
    }

    func testDismissConfirmationDialog() throws {
        confirmationDialogManager.isPresented = true
        manager.dismissConfirmationDialog()
        XCTAssertFalse(confirmationDialogManager.isPresented)
    }

    func testPresentActionSheet() throws {
        let sheet = ActionSheet(
                title: Text(""),
                buttons: []
        )
        manager.presentActionSheet(sheet)
        XCTAssertTrue(actionSheetManager.isPresented)
    }

    func testDismissActionSheet() throws {
        actionSheetManager.isPresented = true
        manager.dismissActionSheet()
        XCTAssertFalse(actionSheetManager.isPresented)
    }

    func testPresentAlert() throws {
        let alert = Alert(
                title: Text(""),
                message: Text(""),
                dismissButton: .cancel())
        manager.presentAlert(alert)
        XCTAssertTrue(alertManager.isPresented)
    }

    func testDismissAlert() throws {
        alertManager.isPresented = true
        manager.dismissAlert()
        XCTAssertFalse(alertManager.isPresented)
    }

    func testPresentDialog() throws {
        manager.presentDialog(
                dismissOnTouchOutside: true,
                Rectangle().eraseToAnyView())
        XCTAssertTrue(dialogManager.isPresented)
    }

    func testDismissDialog() throws {
        dialogManager.isPresented = true
        manager.dismissDialog()
        XCTAssertFalse(dialogManager.isPresented)
    }

    func testDismissSheet() throws {
        sheetManager.presentSheet = true
        sheetManager.presentFullSheet = true
        sheetManager.presentFixedHeightSheet = true

        manager.dismissSheet(type: .normal)
        manager.dismissSheet(type: .full)
        manager.dismissSheet(type: .fixedHeight)

        XCTAssertFalse(sheetManager.presentSheet)
        XCTAssertFalse(sheetManager.presentFullSheet)
        XCTAssertFalse(sheetManager.presentFixedHeightSheet)
    }

    let backStackElement = BackStackElement(
            id: "root",
            wrappedElement: Rectangle().eraseToAnyView(),
            type: .screen,
            addToBackStack: true)

    func testDismiss_toPreviousView() throws {
        manager.push(
                EmptyView(),
                withId: nil,
                addToBackStack: true,
                showDefaultNavBar: true)

        manager.stackItems.append(backStackElement)
        manager.dismiss(type: .toPreviousView)
        XCTAssertTrue(manager.stackItems.isEmpty)
    }

    func testDismiss_toRootView() throws {
        manager.push(
                EmptyView(),
                withId: nil,
                addToBackStack: true,
                showDefaultNavBar: true)
        manager.stackItems.append(backStackElement)
        manager.dismiss(type: .toRootView)
        XCTAssertTrue(manager.stackItems.isEmpty)
    }

    func testDismiss_toView() throws {
        manager.push(
                EmptyView(),
                withId: nil,
                addToBackStack: true,
                showDefaultNavBar: true)
        let backStackElement2 = BackStackElement(
                id: "",
                wrappedElement: Rectangle().eraseToAnyView(),
                type: .screen,
                addToBackStack: true)
        manager.stackItems.append(backStackElement)
        manager.stackItems.append(backStackElement2)
        manager.dismiss(type: .toView(withId: "root"))
        XCTAssertTrue(manager.stackItems.isEmpty)
    }

    func testDismiss_sheet() throws {
        sheetManager.presentSheet = true
        manager.dismiss(type: .sheet())
        XCTAssertFalse(sheetManager.presentSheet)
    }

    func testDismiss_dialog() throws {
        dialogManager.isPresented = true
        manager.dismiss(type: .dialog)
        XCTAssertFalse(dialogManager.isPresented)
    }
}

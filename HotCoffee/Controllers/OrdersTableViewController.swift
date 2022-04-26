//
//  OrdersTableViewController.swift
//  HotCoffee
//
//  Created by Sergio Santos on 24/04/22.
//

import UIKit

class OrdersTableViewController: UITableViewController, AddCoffeeOrderDelegate {
    
    var orderListViewModel = OrderListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        populateOrders()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.orderListViewModel.ordersViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = self.orderListViewModel.orderViewModel(at: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
        
        cell.textLabel?.text = vm.type
        cell.detailTextLabel?.text = vm.size
        
        return cell
    }
    
    private func populateOrders() {
        WebService().load(resource: Order.all) { result in
            
            switch result {
                case .success(let orders):
                    self.orderListViewModel.ordersViewModel = orders.map(OrderViewModel.init)
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
              let addCoffeeOrderVC = navC.viewControllers.first as? AddOrderViewController else {
            fatalError("Error performing segue!")
        }
        
        addCoffeeOrderVC.delegate = self
    }
    
    // MARK: - Delegate functions of AddCoffeeOrderDelegate
    
    func addCoffeeOrderViewControllerDidClose(controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
        
        let orderVM = OrderViewModel(order: order)
        self.orderListViewModel.ordersViewModel.append(orderVM)
        self.tableView.insertRows(at: [IndexPath.init(row: self.orderListViewModel.ordersViewModel.count - 1, section: 0)], with: .automatic)
    }
}

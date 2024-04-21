//
//  DataListView.swift
//  BigDataApp
//
//  Created by Main on 18.04.2024.
//

import SwiftUI
import Combine

fileprivate enum Constants {
    
    static let chevronUp: String = "chevron.up"
}

struct DataListView<DataListInterface>: View where DataListInterface: DataListOutputable & DataListInputable {
    
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    private var isCompact: Bool { horizontalSizeClass == .compact }
#else
    private var isCompact: Bool = false
#endif
    
    @ObservedObject var viewModel: DataListInterface
    
    var body: some View {
        NavigationStack {
            if !isCompact {
                Table(of: Item.self, sortOrder: $viewModel.sortOrder) {
                    TableColumn(ItemKey.id.description, value: \.id.description)
                    TableColumn(ItemKey.name.description, value: \.name)
                    TableColumn(ItemKey.number.description, value: \.number.description)
                } rows: {
                    ForEach($viewModel.filteredItems) { item in
                        TableRow(item.wrappedValue)
                            .contextMenu {
                                contextMenuView(item.wrappedValue)
                            }
                        
                    }
                }
                .searchable(text: $viewModel.searchName)
                .refreshable {
                    viewModel.updateItems()
                }
                .padding(16)
            } else {
                List {
                    Section {
                        ForEach($viewModel.filteredItems) { item in
                            VStack {
                                rowView(item.wrappedValue)
                                    .onAppear {
                                        if viewModel.filteredItems.last == item.wrappedValue {
                                            viewModel.updateItems()
                                        }
                                    }
                            }
                        }
                    } header: {
                        headerView()
                    }
                }
                .listRowSeparator(.visible)
                .listStyle(.plain)
                .listRowInsets(
                    EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16)
                )
                .refreshable {
                    viewModel.updateItems()
                }
                .searchable(text: $viewModel.searchName)
            }
        }
        .alert(isPresented: $viewModel.isFailureAlertShowing) {
            if case .error(let error) = viewModel.activeAlert  {
                return Alert(
                    title:  Text(error.localizedDescription),
                    dismissButton: Alert.Button.default(Text("Ok"), action: { viewModel.clearAlerts()} )
                )
            } else {
                return Alert(
                    title:  Text("Error"),
                    dismissButton: Alert.Button.default(Text("Ok"), action: { viewModel.clearAlerts()} )
                )
            }
        }
        .onAppear {
            viewModel.viewWillAppear()
        }
    }
    
    @ViewBuilder private func contextMenuView(_ item: Item) -> some View {
        Button("Open") {
            print("Opened")
        }
        Divider()
        Button(action: {
            print("Item deleted")
        }, label: {
            Text("Delete")
        })
        .foregroundColor(.white)
        .background(.red)
    }
    
    @ViewBuilder private func rowView(_ item: Item) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(item.id)")
                    .foregroundColor(.gray)
                Text(item.name)
            }
            .frame(maxWidth: UIScreen.main.bounds.width / 3, alignment: .leading)
            
            Spacer()
            
            Text("\(item.number)")
        }
    }
    
    @ViewBuilder private func headerView() -> some View {
        VStack(alignment: .leading) {
            Text("Big Data App")
                .font(.title)
            HStack(spacing: 16) {
                ForEach(ItemKey.allCases) { key in
                    Button(action: {
                        viewModel.changeSortOrder(with: key)
                    }, label: {
                        HStack(alignment: .center, spacing: 4) {
                            Text(key.description)
                            
                            if viewModel.sortOrder[0].keyPath == key.keyPathComparator.keyPath {
                                Image(systemName: Constants.chevronUp)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 10)
                                    .rotationEffect(
                                        viewModel.sortOrder[0].order == .forward
                                        ? Angle(degrees: 0)
                                        : Angle(degrees: 180)
                                    )
                            } else {
                                Spacer()
                                    .frame(width: 10)
                            }
                        }
                    })
                }
            }
        }
    }
}

#Preview {
    DataListView(viewModel: DataListViewModel(itemsGateway: JSONItemsGateway()))
}

//
//  DataListView.swift
//  BigDataApp
//
//  Created by Main on 18.04.2024.
//

import SwiftUI
import Combine

struct DataListView<DataListInterface>: View where DataListInterface: DataListOutputable & DataListInputable {
    
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    private var isCompact: Bool { horizontalSizeClass == .compact }
#else
    private var isCompact: Bool = false
#endif
    
    @ObservedObject var viewModel: DataListInterface
    
    var body: some View {
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
                
            }
            .padding(16)
        } else {
            NavigationStack {
                List {
                    Section {
                        ForEach($viewModel.filteredItems) { item in
                            rowView(item.wrappedValue)
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
                    
                }
            }
            .searchable(text: $viewModel.searchName)
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
                        var keyPathComparator = key.keyPathComparator
                        if keyPathComparator.keyPath == viewModel.sortOrder[0].keyPath {
                            let order: SortOrder = viewModel.sortOrder[0].order == .forward ? .reverse : .forward
                            keyPathComparator.order = order
                        }
                        
                        viewModel.sortOrder = [keyPathComparator]
                    }, label: {
                        HStack(alignment: .center, spacing: 4) {
                            Text(key.description)
                            
                            if viewModel.sortOrder[0].keyPath == key.keyPathComparator.keyPath {
                                Image(systemName: "chevron.up")
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

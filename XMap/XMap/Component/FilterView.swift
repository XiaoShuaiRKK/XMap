//
//  FilterView.swift
//  XMap
//
//  Created by Xiao Shuai on 2025/1/10.
//

import SwiftUI

struct FilterView: View {
    @Binding var selectedIcon: String
    @Binding var selectedColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("筛选选项")
                .font(.headline)
                .padding()
            List {
                Section(header: Text("Icon")) {
                    ForEach(iconsFilter, id: \.self) { icon in
                        Button(action: {
                            selectedIcon = icon == "全部" ? "" : icon
                        }) {
                            HStack {
                                Image(systemName: icon == "全部" ? "circle" : icon)
                                Text(icon == "全部" ? "全部" : icon)
                                Spacer()
                                if(icon == "全部" && selectedIcon == "") || selectedIcon == icon {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                Section(header: Text("Color")) {
                    ForEach(colorsFilter, id: \.self) { color in
                        Button(action: {
                            selectedColor = color == .clear ? .clear : color
                        }) {
                            HStack {
                                Circle().fill(color == .clear ? .white : color).frame(width: 20, height: 20)
                                Text(color == .clear ? "全部" : color.description.capitalized)
                                Spacer()
                                if (color == .clear && selectedColor == .clear) || selectedColor == color {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .frame(maxWidth: 300)
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}

#Preview {
    @State var icon: String = ""
    @State var color: Color = .clear
    FilterView(selectedIcon: $icon, selectedColor: $color)
}

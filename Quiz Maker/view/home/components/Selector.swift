import SwiftUI

struct Selector: View {
    let options: [String]
    @Binding var selectedOption: String
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(options, id: \.self) { option in
                    let isSelected = selectedOption == option

                    Text(LocalizedStringKey(option))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(isDarkMode ? .white : (isSelected ? .white : .black))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(isSelected ? Color.blue : Color.clear)
                        .clipShape(Capsule())
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedOption = option
                        }
                }
            }
            .frame(height: 36)
            .padding(4)
            .background(isDarkMode ? Color(.systemGray6) : Color(.systemGray5))
            .clipShape(Capsule())
        }
        .onAppear {
            for option in options {
                let localized = NSLocalizedString(option, comment: "")
                print("Key: \(option), Localized: \(localized)")
            }
        }
    }

}


#Preview {
    struct SelectorPreviewWrapper: View {
        @State private var selected = "Option 1"
        
        var body: some View {
            Selector(
                options: ["Option 1", "Option 2", "Option 3"],
                selectedOption: $selected
            )
            .padding()
        }
    }

    return SelectorPreviewWrapper()
}

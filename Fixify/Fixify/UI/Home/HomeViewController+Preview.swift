#if DEBUG
import SwiftUI

struct HomeVCPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        UINavigationController(rootViewController: HomeViewController())
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct HomeVCPreview_Previews: PreviewProvider {
    static var previews: some View {
        HomeVCPreview()
            .edgesIgnoringSafeArea(.all)
            .previewDisplayName("Home - My Requests")
    }
}
#endif


//
//  OnboardingView.swift
//  OnboardingSUI
//
//  Created by Kirill Khomicevich on 24.01.2025.
//

import SwiftUI

enum OnboardingPage: Int, CaseIterable {
    case browseMenu, quickDelivery, orderTracking
    
    var title: String {
        switch self {
            case .browseMenu:
                return "Browser Menus"
            case .quickDelivery:
                return "Lightning Fast Delivery"
            case .orderTracking:
                return "Real-Time Order Tracking"
        }
    }

    var description: String {
        switch self {
            case .browseMenu:
                return "Discover a world of delicious meals from local chefs."
            case .quickDelivery:
                return "From your kitchen to your table in just 30 minutes."
            case .orderTracking:
                return "Watch your order progress in real time."
        }
    }
}

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var isAnimating = false
    @State private var deliveryOffset = false
    @State private var trackingProgress: CGFloat = 0
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(OnboardingPage.allCases, id: \.rawValue) { page in
                    getPageView(for: page)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.spring(), value: currentPage)
            
            HStack(spacing: 12) {
                ForEach(0..<OnboardingPage.allCases.count, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color.blue : Color.gray.opacity(0.5))
                        .frame(width: currentPage == index ? 12 : 8, height: currentPage == index ? 12 : 8)
                        .animation(.spring(), value: currentPage)
                }
            }
            .padding(.bottom, 20)
            
            Button {
                withAnimation(.spring()) {
                    if currentPage < OnboardingPage.allCases.count {
                        currentPage += 1
                        isAnimating = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isAnimating = true
                        }
                    } else {
                        
                    }
                }
            } label: {
                Text(currentPage < OnboardingPage.allCases.count ? "Next" : "Get Started")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(colors: [Color.blue, Color.blue.opacity(0.5)],
                                       startPoint: .leading,
                                       endPoint: .trailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color.blue.opacity(0.4), radius: 5, x: 0, y: 5)
                
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 12)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation {
                    isAnimating = true
                }
            }
        }
    }

}

// MARK: - Private methods
private extension OnboardingView {

    var foodImageGroup: some View {
        ZStack {
            Image("burger")
                .resizable()
                .scaledToFit()
                .frame(height: 160)
                .offset(y: isAnimating ? 0 : 40)
                .animation(.spring(dampingFraction: 0.8).delay(0.3), value: isAnimating)
                .zIndex(1)
            Image("fries")
                .resizable()
                .scaledToFit()
                .frame(height: 180)
                .scaleEffect(x: -1, y: 1)
                .rotationEffect(.degrees(-15))
                .offset(x: -120, y: isAnimating ? 0 : 60)
                .animation(.spring(dampingFraction: 0.8).delay(0.3), value: isAnimating)
            
            Image("cola")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .rotationEffect(.degrees(15))
                .offset(x: 120, y: isAnimating ? 0 : 60)
                .animation(.spring(dampingFraction: 0.8).delay(0.3), value: isAnimating)
        }
    }
    
    var deliveryAnimation: some View {
        ZStack {
            Circle()
                .stroke(Color.blue.opacity(0.2), lineWidth: 2)
                .frame(width: 250, height: 250)
                .scaleEffect(isAnimating ? 1.1 : 0.9)
                .animation(.easeInOut(duration: 1.5).repeatForever(), value: isAnimating)
            Image("delivery")
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .rotationEffect(.degrees(15))
                .offset(y: deliveryOffset ? -20 : 0)
                .rotationEffect(.degrees(deliveryOffset ? 5 : -5))
                .opacity(isAnimating ? 1 : 0)
                .animation(.spring(dampingFraction: 0.7).delay(0.2), value: isAnimating)
            
            ForEach(0..<8) { index in
                Circle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: 8, height: 8)
                    .offset(
                        x: 120 * cos(Double(index) * .pi / 4),
                        y: 120 * sin(Double(index) * .pi / 4)
                    )
                    .scaleEffect(isAnimating ? 1 : 0)
                    .opacity(isAnimating ? 0.7 : 0)
                    .animation(
                        .easeInOut(duration: 1.5)
                        .repeatForever()
                        .delay(Double(index) * 0.1), value: isAnimating
                    )
            }
        }
    }
    
    private var orderTrackingAnimation: some View {
        ZStack {
            Circle()
                .stroke(Color.blue.opacity(0.2), lineWidth: 2)
                .frame(width: 250, height: 250)
                .scaleEffect(isAnimating ? 1.1 : 0.9)
                .animation(.easeInOut(duration: 1.5).repeatForever(), value: isAnimating)
            
            Image("fries")
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .rotationEffect(.degrees(15))
                .opacity(isAnimating ? 1 : 0)
                .scaleEffect(isAnimating ? 1 : 0)
                .rotation3DEffect(.degrees(isAnimating ? 360 : 1), axis: (x: 0, y: 1, z: 0))
                .animation(.spring(dampingFraction: 0.7).delay(0.2), value: isAnimating)
            
            ForEach(0..<4) { index in
                Image(systemName: "location.fill")
                    .foregroundStyle(Color.blue)
                    .offset(
                        x: 150 * cos(Double(index) * .pi / 2),
                        y: 150 * sin(Double(index) * .pi / 2)
                    )
                    .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(isAnimating ? 1 : 0)
                    .animation(.spring(dampingFraction: 0.6).delay(Double(index) * 0.1),
                               value: isAnimating)
            }
        }
    }
    @ViewBuilder
    func getPageView(for page: OnboardingPage) -> some View {
        VStack(spacing: 30) {
            ZStack {
                switch page {
                    case .browseMenu:
                        foodImageGroup
                    case .quickDelivery:
                        deliveryAnimation
                    case .orderTracking:
                        orderTrackingAnimation
                }
            }
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 32, weight: .bold, design: .default))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.spring(dampingFraction: 0.8).delay(0.3), value: isAnimating)
                Text(page.description)
                    .font(.system(size: 24, weight: .medium, design: .default))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.spring(dampingFraction: 0.8).delay(0.3), value: isAnimating)
            }
        }
        .padding(.top, 50)
    }
}

#Preview {
    OnboardingView()
}

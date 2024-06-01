//
//  SwiperView.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/17/24.
//

import SwiftUI


struct SwiperView: View {
    @ObservedObject var vm: RestaurantListViewModel
    
    @State private var currentIndex: Int = 0
    @State private var offset = CGSize.zero
    @State private var offsetTwo = CGSize.zero

    @State private var rotationAngle: Double = 0
        
    @State private var tab = "3"
    
    @Binding var selectedTab: String
    
    @Binding var savedRestaurant: RestaurantViewModel?
    
    @Binding var restaurants: [RestaurantViewModel]

    
    @Binding var isNewSearch: Bool
    @Binding var topIndex: Int
    @Binding var bottomIndex: Int
    @Binding var searching: Bool
    @Binding var didSubmit: Bool
    @Environment(\.presentationMode) var presentationMode
    @State private var instructionsClicked = false
    @Binding var firstSearch: Bool

    
    
    var body: some View {
        ZStack {
            Color.uncBlue
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        selectedTab = "1"
                    }label: {
                        Image(systemName: "house.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(Color.darkerblue)
                            .padding(.leading, 15)

                    }
                    Spacer()
                    Text("Game Time!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.darkerblue)
                        .italic()
                    Spacer()
                    Button {
                        instructionsClicked = true
                    } label: {
                        Image(systemName: "info.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(Color.darkerblue)
                            .padding(.trailing, 15)
                    }
                }
                    .background(
                Rectangle()
                    .frame(width: 400, height: 72)
                    .foregroundColor(.white)
                    )
                Spacer()
                if (firstSearch) {
                    VStack(alignment: .center) {
                        Spacer()
                        Text("Choose filters to search for restaurants!")
                            .multilineTextAlignment(.center)
                            .font(.title2)
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                        Spacer()
                    }
                }
                else if restaurants.isEmpty && searching == true {
                    VStack {
                        Spacer()
                        Text("Loading restaurants...")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                        Spacer()
                    }
                } else if (restaurants.isEmpty && searching == false) {
                    VStack(alignment: .center) {
                        Spacer()
                        Text("No restaurants found :(")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                        Text("Try altering your search")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                        Spacer()
                    }
                }
                else {
                    if restaurants.count == 1 {
                        CardView(restaurant: restaurants[0])
                            .rotationEffect(.degrees(rotationAngle))
                            .animation(.easeInOut(duration: 1.0))
                            .onAppear {
                                // Start the animation when the view appears
                                withAnimation {
                                    rotationAngle += 720 // Rotate one full circle
                                }
                            }
                        Button {
                            savedRestaurant = restaurants[0]
                            selectedTab = "3"
                            didSubmit = true
                            print("clicked favorites button")
                        }label: {
                            Text("Click to add to favorites")
                                .padding()
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.white)
                                        .shadow(radius: 2)
                                )
                        }
                        .padding(.top, 40)
                        
                        Spacer()
                    }
                    
                    else {
                        // current restaurant
                        Text("Restaurants Remaining: \(restaurants.count)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(color:.gray, radius: 5)
                        
                        CardView(restaurant: restaurants[topIndex])
                            .padding()
                            .offset(x: offset.width, y: offset.height * 0.4)
                            .rotationEffect(.degrees(Double(offset.width / 80)))
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        offset = gesture.translation
                                    }
                                    .onEnded { value in
                                        // Deletes if you swipe left
                                        //                                    if value.translation.width < -100 || value.translation.width > 100{
                                        //                                        // removes top restaurant
                                        //                                        self.removeCurrentRestaurant()
                                        //                                    }
                                        SwipeCard(width: offset.width)
                                    }
                                
                            )
                        if restaurants.count != 1 {
                            Text("VS")
                                .font(.title)
                                .italic()
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .shadow(color:.gray, radius: 5)
                        }
                        
                        //next restaurant if available
                        if bottomIndex < restaurants.count && bottomIndex != topIndex {
                            CardView(restaurant: restaurants[bottomIndex])
                                .padding()
                                .offset(x: offsetTwo.width, y: offsetTwo.height * 0.4)
                                .rotationEffect(.degrees(Double(offsetTwo.width / 80)))
                                .gesture(
                                    DragGesture()
                                        .onChanged { gesture in
                                            offsetTwo = gesture.translation
                                        }
                                        .onEnded { value in
                                            // Deletes if you swipe left
                                            //                                        if value.translation.width < -100 || value.translation.width > 100 {
                                            //                                            // removes top restaurant
                                            //                                            self.removeSecondRestaurant()
                                            //                                        }
                                            SwipeSecondCard(width: offsetTwo.width)
                                        }
                                    
                                )
                            Spacer()
                        }
                    }
                }
            }.overlay {
                if (instructionsClicked) {
                    Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                    InstructionsView(selectedTab: $selectedTab)
                        .padding(6)
                        .multilineTextAlignment(.leading)
                        .frame(width: 350, height: 500, alignment: .topLeading)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 1)
                                .fill(Color.white)
                        }.overlay(alignment: .topTrailing) {
                            Button {
                                instructionsClicked = false
                            }label: {
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .padding(.top, 20)
                                    .padding(.trailing, 10)
                            }.padding(.trailing, 15)
                                .padding(.top, 10)
                        }
                }
            }
        }.onChange(of: vm.restaurants, initial: true) { oldRestaurants, newRestaurants in
            // Update restaurants when vm.restaurants changes
            if !newRestaurants.isEmpty {
                print("this ran")
                restaurants = newRestaurants
            }
        }.onAppear{
            print("swiper count: \(restaurants.count)")
        }

    }
    
    private func setRestaurant() {
        restaurants = [restaurants[0]]
    }
    
    private func SwipeCard(width: CGFloat) {
        isNewSearch = false
        withAnimation(.easeInOut(duration: 0.2)) {
            switch width {
            case -500...(-120):
                offset = CGSize(width: -500, height: 0)
                removeCurrentRestaurant()
            case 120...(500):
                offset = CGSize(width: 500, height: 0)
                removeCurrentRestaurant()
            default:
                offset = .zero
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            offset = .zero
        }
        
    }
    private func SwipeSecondCard(width: CGFloat) {
        isNewSearch = false
        withAnimation(.easeInOut(duration: 0.2)) {
            switch width {
            case -500...(-120):
                offsetTwo = CGSize(width: -500, height: 0)
                removeSecondRestaurant()
            case 120...(500):
                offsetTwo = CGSize(width: 500, height: 0)
                removeSecondRestaurant()
            default:
                offsetTwo = .zero
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            offsetTwo = .zero
        }
    }
    
    // remove the current restaurant and update index
    private func removeCurrentRestaurant() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            if topIndex < restaurants.count {
                restaurants.remove(at: topIndex)
                if topIndex < bottomIndex {
                    bottomIndex = 0
                    topIndex = bottomIndex + 1
                }
            }
            // Reset index if it exceeds the bounds of the array
            if topIndex >= restaurants.count {
                topIndex = 0
            }
//            if restaurants.count == 1 {
//                winner = restaurants[0]
//            }
        }
    }
    private func removeSecondRestaurant() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            if bottomIndex < restaurants.count {
                restaurants.remove(at: bottomIndex)
                if bottomIndex < topIndex {
                    topIndex = 0
                    bottomIndex = topIndex + 1
                }
                
            }
            // Reset index if it exceeds the bounds of the array
            if bottomIndex >= restaurants.count {
                bottomIndex = 0
            }
//            if restaurants.count == 1 {
//                winner = restaurants[0]
//            }
        }
    }

}

//
//#Preview {
//    SwiperView(vm: RestaurantListViewModel(), isNewSearch: true)
//}

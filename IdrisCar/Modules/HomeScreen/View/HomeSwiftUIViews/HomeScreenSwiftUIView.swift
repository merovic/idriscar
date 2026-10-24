//
//  HomeScreenSwiftUIView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 02/03/2025.
//

import SwiftUI
import Combine

struct HomeScreenSwiftUIView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ImageCarouselView(
                data: viewModel.slideshow.compactMap { item in
                    guard let image = item.image else { return nil }
                    return CarouselItem(imagePath: image)
                },
                isLoading: viewModel.isAnimating,
                selectedSliderImage: .constant(nil)
            )
            
            if viewModel.isAnimating || !viewModel.brands.isEmpty {
                CarBrandsView(
                    brands: viewModel.brands,
                    isLoading: viewModel.isAnimating,
                    onBrandSelected: { selectedBrand in
                        print("Selected Brand: \(selectedBrand.name)")
                        viewModel.goToCarsWithBrand(brandID: String(selectedBrand.id))
                    },
                    onViewMoreTapped: {
                        viewModel.goToBrands()
                    }
                )
            }
            
            if viewModel.isAnimating || !viewModel.cars.isEmpty {
                CarsListView(
                    cars: viewModel.cars,
                    isLoading: viewModel.isAnimating,
                    onCarSelected: { selectedCar in
                        print("Selected Car: \(selectedCar.name)")
                        viewModel.selectedCar = selectedCar
                        viewModel.goToCarDetails()
                    },
                    onViewMoreTapped: {
                        viewModel.goToCars()
                    }
                )
                .padding(.vertical)
            }
            
            if viewModel.isAnimating || !viewModel.services.isEmpty {
                ServicesListView(
                    services: viewModel.services,
                    isLoading: viewModel.isAnimating,
                    onServiceSelected: { selectedService in
                        print("Selected Service: \(selectedService.name)")
                        viewModel.selectedService = selectedService
                        viewModel.goToServiceDetails()
                    },
                    onViewMoreTapped: {
                        print("Services Clicked")
                        viewModel.goToServices()
                    }
                )
                .padding(.vertical)
            }
            
            if viewModel.isAnimating || !viewModel.offers.isEmpty {
                OffersListSwiftUIView(
                    offers: viewModel.offers,
                    isLoading: viewModel.isAnimating,
                    onOfferSelected: { selectedOffer in
                        print("Selected Offer: \(selectedOffer.name)")
                        viewModel.selectedOffer = selectedOffer
                        viewModel.goToOfferDetails()
                    },
                    onViewMoreTapped: {
                        print("Offers Clicked")
                        viewModel.goToOffers()
                    }
                )
                .padding(.vertical)
            }
            
            if viewModel.isAnimating || !viewModel.banks.isEmpty {
                BanksListView(
                    banks: viewModel.banks,
                    isLoading: viewModel.isAnimating
                )
                    .padding(.vertical)
            }
        }
    }
}

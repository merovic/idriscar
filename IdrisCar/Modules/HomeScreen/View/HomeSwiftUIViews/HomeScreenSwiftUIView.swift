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
                selectedSliderImage: .constant(nil)
            )
            
            if !viewModel.brands.isEmpty {
                CarBrandsView(
                    brands: viewModel.brands,
                    onBrandSelected: { selectedBrand in
                        print("Selected Brand: \(selectedBrand.name)")
                        viewModel.goToCarsWithBrand(brandID: String(selectedBrand.id))
                    },
                    onViewMoreTapped: {
                        viewModel.goToBrands()
                    }
                )
            }
            
            if !viewModel.cars.isEmpty {
                CarsListView(
                    cars: viewModel.cars,
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
            
            if !viewModel.services.isEmpty {
                ServicesListView(
                    services: viewModel.services,
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
            
            if !viewModel.offers.isEmpty {
                OffersListSwiftUIView(
                    offers: viewModel.offers,
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
            
            if !viewModel.banks.isEmpty {
                BanksListView(banks: viewModel.banks)
                    .padding(.vertical)
            }
        }
    }
}

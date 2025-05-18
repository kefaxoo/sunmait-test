//
//  NewsItemView.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import SwiftUI

struct NewsItemView: View {
    let news: any NewsProtocol
    let contentType: NewsContentType
    
//    @Binding var showBlockAlert: Bool
    
    var removeFavorite: ((_ id: String) -> Void)?
    
    @State private var id = UUID()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.white)
            HStack(spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundStyle(.beige)
                    Image(systemName: "newspaper.fill")
                        .foregroundStyle(.customBlue)
                        .frame(maxWidth: 24, maxHeight: 20)
                }
                .frame(width: 94, height: 86)
                VStack(alignment: .leading, spacing: 8) {
                    Text(self.news.webTitle)
                        .foregroundStyle(.customBlack)
                        .lineLimit(3)
                        .font(.system(size: 17, weight: .bold))
                    HStack {
                        Text(self.news.pillarName)
                            .foregroundStyle(.customGray)
                            .lineLimit(1)
                            .font(.system(size: 15, weight: .medium))
                        if let date = self.news.dateString {
                            RoundedRectangle(cornerRadius: 2)
                                .foregroundStyle(.customGray)
                                .frame(width: 4, height: 4)
                            Text(date)
                                .foregroundStyle(.customGray)
                                .lineLimit(1)
                                .font(.system(size: 15, weight: .medium))
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)
                VStack {
                    Menu {
                        if self.contentType != .blocked {
                            if RealmManager.favorites.isFavorite(self.news) {
                                Button {
                                    self.removeFavorite?(self.news.id)
                                    if self.contentType == .all {
                                        self.id = UUID()
                                    }
                                } label: {
                                    Label("Remove from Favorites", systemImage: "heart.slash")
                                }
                            } else if let news = self.news as? News {
                                Button {
                                    RealmManager.favorites.write(news: news) {
                                        self.id = UUID()
                                    }
                                } label: {
                                    Label("Add to Favorites", systemImage: "heart")
                                }
                            }
                        }
                        Button(role: .destructive) {
//                            self.showBlockAlert = true
                        } label: {
                            Label("Block", systemImage: "nosign")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 20, weight: .light))
                            .foregroundStyle(.customGray)
                    }
                    .id(self.id)
                    Spacer()
                }
                .padding(.leading, 16)
            }
            .padding(12)
        }
        .padding(.horizontal, 16)
        .onTapGesture {
            guard let url = URL(string: self.news.webUrl),
                  UIApplication.shared.canOpenURL(url)
            else { return }
            
            UIApplication.shared.open(url)
        }
    }
}

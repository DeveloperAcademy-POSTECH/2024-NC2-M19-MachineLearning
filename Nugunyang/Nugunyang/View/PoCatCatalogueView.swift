//
//  PoCatCatalogueView.swift
//  Nugunyang
//
//  Created by 원주연 on 6/17/24.
//

import SwiftUI
import SwiftData

struct PoCatCatalogueView: View {
    //    let pocatsMain: [String] =  ["노벨이"]
    //    let pocatJigok: [String] = ["치즈스틱", "깜냥이1", "깜냥이2", "깜냥이3", "삼색이", "다크초코", "인절미", "고등어"]
    
    let columns = [GridItem(.adaptive(minimum: 100))]
    let font = "NanumYeBbeunMinGyeongCe"
    
    //    @Query var cats: [Cat]
    //    var Novel: Cat? {
    //        return self.cats.filter({ $0.name == "model.resultString" }).first
    //    }
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Cat.index, order: .forward) var cats: [Cat]
    
    
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                ZStack{
                    Color.black
                        .ignoresSafeArea(.all)
                }
                
                LazyVStack(pinnedViews: .sectionHeaders) {
                    Section(header: HeaderView()){
                        VStack(alignment: .leading) {
                            
                            Spacer().frame(height: 30)
                            
                            Text("📍 본관 정원")
                                .foregroundStyle(Color.gray)
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            VStack{
                                if cats[0].meetCount == 1 {
                                    Image(cats[0].name_0).resizable()
                                        .frame(width: 100, height: 100)
                                } else {
                                    Image(cats[0].name).resizable()
                                        .frame(width: 100, height: 100)
                                }
                                Text(cats[0].realName)
                                    .foregroundStyle(Color.white)
                                    .font(.custom(font, size: 20))
                                    .padding(.horizontal, 10)
                            }
                            
                            Spacer().frame(height: 30)
                            
                            Text("📍 지곡회관 1층 & 연못 근처")
                                .foregroundStyle(Color.gray)
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(1..<9) { n in
                                    VStack{
                                        if cats[n].meetCount == 1 {
                                            Image(cats[n].name_0).resizable()
                                                .frame(width: 100, height: 100)
                                        } else {
                                            Image(cats[n].name).resizable()
                                                .frame(width: 100, height: 100)
                                        }
                                        Text(cats[n].realName)
                                            .foregroundStyle(Color.white)
                                            .font(.custom(font, size: 20))
                                            .padding(.horizontal, 10)
                                    }
                                    
                                }
                            }
                        }.padding(.horizontal)
                    }
                }
            }
            .clipped()
        }
    }
}

// Sticky Header
private struct HeaderView: View{
    let font = "NanumYeBbeunMinGyeongCe"
    
    fileprivate var body: some View {
        HStack {
            Spacer()
            Image("냥케치")
            Spacer().frame(width: 25)
            Text("포스텍 냥도감")
                .font(.custom(font, size: 40))
                .foregroundStyle(Color.white)
            Spacer()
        }
        .background(Color.black)
    }
}

private struct CellItemView: View {
    private var cat: String
    let font = "NanumYeBbeunMinGyeongCe"
    
    fileprivate init(cat: String) {
        self.cat = cat
    }
    
    fileprivate var body: some View {
        Text(cat)
            .foregroundStyle(Color.white)
            .font(.custom(font, size: 20))
    }
}

#Preview {
    PoCatCatalogueView()
}


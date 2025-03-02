//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Result: Codable {
    var id: Int
    var date: String
    var team: String
    var opponent: String
    var isHomeGame: Bool
    var score: Score
}

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct ContentView: View {
    @State private var results = [Result]()
    var body: some View {
        List(results, id: \.id) { item in
            VStack(alignment: .leading) {
                HStack {
                    Text("\(item.team) vs. \(item.opponent)")
                    Spacer()
                    Text("\(item.score.unc) - \(item.score.opponent)")
                        .foregroundStyle(item.score.unc > item.score.opponent ? Color.blue : Color.primary)
                }
                .fontWeight(.semibold)
                HStack {
                    Text(item.date)
                    Spacer()
                    Text(item.isHomeGame ? "Home" : "Away")
                }
                .foregroundStyle(.secondary)
                .font(.headline)
            }
        }
        .task {
            await loadData()
        }
    }

    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid url")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([Result].self, from: data) {
                results = decodedResponse
                print("Loaded results:", results)
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}

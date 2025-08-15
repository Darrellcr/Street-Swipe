//
//  SpriteSheetComponent.swift
//  c5a09
//
//  Created by Nicholas Sindoro on 22/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

extension SKTexture {
    /// Memecah sprite‑sheet ber‐grid menjadi array texture.
    /// - Parameters:
    ///   - columns: jumlah kolom
    ///   - rows:    jumlah baris
    ///   - margin:  piksel kosong di tepi luar sheet (default 0)
    ///   - spacing: jarak antar‐cell di dalam sheet (default 0)
    /// - Returns:   `[SKTexture]` urut kiri→kanan, atas→bawah
    static func frames(fromSheetNamed name: String,
                       columns: Int,
                       rows: Int,
                       margin: CGFloat = 0,
                       spacing: CGFloat = 0) -> [SKTexture] {

        let sheet = SKTexture(imageNamed: name)
        sheet.filteringMode = .nearest           // pixel‑art friendly

        let pixelW  = sheet.size().width
        let pixelH  = sheet.size().height

        let cellW = (pixelW - 2*margin - spacing*CGFloat(columns-1)) / CGFloat(columns)
        let cellH = (pixelH - 2*margin - spacing*CGFloat(rows-1))    / CGFloat(rows)

        var frames: [SKTexture] = []

        for row in 0..<rows {
            for col in 0..<columns {
                let x = margin + CGFloat(col) * (cellW + spacing)
                let y = margin + CGFloat(rows-1-row) * (cellH + spacing)   // baris 0 = atas
                let rect = CGRect(x: x/pixelW,
                                  y: y/pixelH,
                                  width: cellW/pixelW,
                                  height: cellH/pixelH)
                frames.append(SKTexture(rect: rect, in: sheet))
            }
        }
        return frames
    }
}

class SpriteSheetComponent: GKComponent {
    let textureFrames: [SKTexture]
    var curIndex = 0
    var updateTime: CGFloat
    var curTime: CGFloat
    
    init(sheetName: String, columns: Int, rows: Int, updateTime: CGFloat = 0.1){
        self.textureFrames = SKTexture.frames(fromSheetNamed: sheetName, columns: columns, rows: rows)
        self.updateTime = updateTime
        self.curTime = updateTime
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        curTime -= CGFloat(seconds)
        if curTime <= 0 {
            curIndex = (curIndex + 1) % textureFrames.count
            curTime += updateTime
        }
        
        guard let renderComponent = entity?.component(ofType: RenderComponent.self)
        else {
            assert(false, "Missing required component: RenderComponent")
            return
        }
        renderComponent.node.texture = textureFrames[curIndex]
    }
}

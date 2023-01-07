//
//  ProgressBar.swift
//  Cat.io
//
//  Created by Jacob Wise on 1/7/23.
//

import Foundation
import SpriteKit
//some comments might be self explanatory but want to cover all bases and just go through it
class ProgressBar: SKNode
{
    //set the min and max values for progress, needs to be float
    private var progress = CGFloat(0)
    private var maxProgress = CGFloat(9)
    
    //max width set to 0 initially and then calculated in get sceneframe
    private var maxProgressBarWidth = CGFloat(0)
    
    //in my instance, this game, it is best to just add the pb to the scene, but maybe for world boss's experience bar it will differ
    //i believe this implementation to still be the best option for the boss' health, user health in pvp and boss health in pve
    private var progressBar = SKSpriteNode()
    private var progressBarContainer = SKSpriteNode()
    
    //we set the texture we will use, this is in the asset folder
    private let progressTexture = SKTexture(imageNamed: "ProgressBar")
    private let progressContainerTexture = SKTexture(imageNamed: "ProgressBarContainer")
    
    //this is to tell us the size of the scene that is calling ProgressBar and so we can accurately create the height and width we want
    private var sceneFrame = CGRect()
    
    //we want to build out our progress bar now, but because we need to pass in the sceneFrame from above, we cannot do it inside the init function
    override init()
    {
        super.init()
    }
    
    //so we make a function that can be called from within our game scene
    func buildProgressBar()
    {
        //we will add our progress bar and container as children to this sknode
        self.progressBarContainer = SKSpriteNode(texture: self.progressContainerTexture, size: self.progressContainerTexture.size())
        //here we are setting the width and height using an arbitrary percentage of the size of the parent scene that want it to be
        self.progressBarContainer.size.height = self.sceneFrame.height * 0.1
        self.progressBarContainer.size.width = self.sceneFrame.width * 0.7
        
        
        //repeat above step for the progress bar
        //we will be editing the size of this progress bar as the way of the showing progress
        self.progressBar = SKSpriteNode(texture: self.progressTexture, size: self.progressTexture.size())
        //which is why these values are much smaller
        self.progressBar.size.height = self.sceneFrame.height * 0.08
        self.progressBar.size.width = 0
        
        //we set the anchorpoint of the progress bar to the far left side and centered
        self.progressBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        
     
        self.progressBar.position.x = -self.maxProgressBarWidth / 2.0
        
        self.progressBar.zPosition = 10
        self.progressBarContainer.zPosition = 9
        self.addChild(self.progressBar)
        self.addChild(self.progressBarContainer)

        
    }
    
    func updateProgressBar()
    {
        //we will do an skaction to change the width of the progress bar to update the progress
        //toWidth is solved in the same way youwould solve something's progress
        //duration is arbitrary
        if (self.progress >= self.maxProgress) { return }
        self.progressBar.run(SKAction.resize(toWidth: CGFloat(self.progress/self.maxProgress) * self.maxProgressBarWidth, duration: 0.2))
        self.progress += 1
    }
    
    //function to fill out that scene frame value used above
    func getSceneFrame(sceneFrame: CGRect)
    {
        self.sceneFrame = sceneFrame
        
        self.maxProgressBarWidth = sceneFrame.width * 0.7
    }
    
    //now let's move over to the file "GameScene.swift" where we will add this node as a child to that scene
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

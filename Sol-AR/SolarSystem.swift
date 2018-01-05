//
//  ViewController.swift
//  ArTestOne
//
//  Created by amota511 on 11/9/17.
//  Copyright © 2017 Aaron Motayne. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class SolarSystem: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var timer = Timer()
    var rootNode = SCNNode()
    var sunNode: SCNNode!
    var earthNode: SCNNode!
    var titleLabel : UILabel? = UILabel()
    var featureFindingDescriptionLabel : UILabel? = UILabel()
    var featureFoundIndicatorSquare: UIView? = UIView()
    
    var sunIsSpinning = false
    var rootIsSet = false
    var featurePointFound = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        displayInstructions()
        addTapGestureToSceneView()
        scheduledTimerWithTimeInterval()
    }
    
    func displayInstructions() {
        createTitle()
        createFindFeatureDscriptionLabel()
        createFeatureFoundSquareIndicator()
    }
    
    func createTitle() {
        
        titleLabel?.text = "Sol-AR"
        titleLabel?.textAlignment = .center
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont(name: "Kohinoor Bangla", size:  45.0)
        
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        sceneView.addSubview(titleLabel!)
        
        titleLabel?.topAnchor.constraint(equalTo: sceneView.topAnchor, constant: 25).isActive = true
        titleLabel?.centerXAnchor.constraint(equalTo: sceneView.centerXAnchor).isActive = true
        titleLabel?.widthAnchor.constraint(equalTo: sceneView.widthAnchor).isActive = true
        titleLabel?.heightAnchor.constraint(equalTo: sceneView.heightAnchor, multiplier: 1/4).isActive = true
    }
    
    func createFindFeatureDscriptionLabel() {
        
        featureFindingDescriptionLabel?.text = "For Best Results Point Camera At A Flat Surface Then Slowly Move Camera Closer To Then Further Away From The surface Until The Square Disapears"
        featureFindingDescriptionLabel?.textAlignment = .center
        featureFindingDescriptionLabel?.textColor = .white
        featureFindingDescriptionLabel?.lineBreakMode = .byWordWrapping
        featureFindingDescriptionLabel?.numberOfLines = 0
        featureFindingDescriptionLabel?.font = UIFont(name: "Kohinoor Bangla", size:  15.0)
        
        featureFindingDescriptionLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        sceneView.addSubview(featureFindingDescriptionLabel!)
        
        featureFindingDescriptionLabel?.bottomAnchor.constraint(equalTo: sceneView.bottomAnchor, constant: 0).isActive = true
        featureFindingDescriptionLabel?.centerXAnchor.constraint(equalTo: sceneView.centerXAnchor).isActive = true
        featureFindingDescriptionLabel?.widthAnchor.constraint(equalTo: sceneView.widthAnchor).isActive = true
        featureFindingDescriptionLabel?.heightAnchor.constraint(equalTo: sceneView.heightAnchor, multiplier: 1/4).isActive = true
        
    }
    
    func createFeatureFoundSquareIndicator() {
        
        featureFoundIndicatorSquare?.layer.borderColor = UIColor.red.cgColor
        featureFoundIndicatorSquare?.layer.borderWidth = 3
        
        let size = CGSize(width: sceneView.bounds.size.width / 5, height: sceneView.bounds.size.width / 5)
        
        featureFoundIndicatorSquare?.frame.size = size
        featureFoundIndicatorSquare?.center = sceneView.center
        
        sceneView.addSubview(featureFoundIndicatorSquare!)
        
        animateSqaureScaling()
    }
    
    func animateSqaureScaling() {

        let size = CGSize(width: self.sceneView.bounds.size.width / 4, height: self.sceneView.bounds.size.width / 4)

        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       options: [.repeat,.autoreverse],
                       animations: {
                        self.featureFoundIndicatorSquare?.frame.size = size
                        self.featureFoundIndicatorSquare?.center = self.sceneView.center
        },
                       completion: nil
        )
        
    }
    
    func updateFeatureFoundDesctionLabel(text: String) {
        featureFindingDescriptionLabel?.text = text
    }
    
    func removeIntroduction() {
        
        titleLabel?.removeFromSuperview()
        titleLabel = nil
        
        featureFoundIndicatorSquare?.removeFromSuperview()
        featureFoundIndicatorSquare = nil
    }
    
    func scheduledTimerWithTimeInterval() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(featurePointScan), userInfo: nil, repeats: true)
    }
    
    @objc func featurePointScan() {
        
        checkFeaturePointsAtCenterScreen()
    }
    
    @objc func stopFeaturePointScan() {
        timer.invalidate()
    }
    
    func createRoot(x: Float = 0, y: Float = 0, z: Float = -0.2) {
        
        rootNode.scale = SCNVector3(2,2,2)
        
        sceneView.scene.rootNode.addChildNode(rootNode)
        
        rootNode.position = SCNVector3(x,y,z)
        rootNode.runAction(SCNAction.rotateBy(x: 0, y: 0.785398, z: 0, duration: 0.0))
        
        createSpaceBox()
        createSolarSystem()
    }
    
    
    func createSpaceBox() {
        addBackSpacePlane()
        addSideSpacePlane()
        addBottomSpacePlane()
    }
    
    func createSolarSystem() {
        addMainLight()
        addSun()
        addMercury()
        addVenus()
        addEarth()
        addMars()
        addJupiter()
        addSaturn()
        addUranus()
        addNeptune()
        addPluto()
    }
    
    func addBackSpacePlane() {
        
        let space = SCNPlane(width: 0.22, height: 0.06)
        space.firstMaterial?.diffuse.contents = nil
        space.firstMaterial?.isDoubleSided = true
        let spaceNode = SCNNode(geometry: space)
        spaceNode.rotation = SCNVector4(0.0,0.0,0.0,0.0)
        spaceNode.position = SCNVector3(0,-0.01,-0.1)
        rootNode.addChildNode(spaceNode)
    }
    
    func addSideSpacePlane() {
        
        let space = SCNPlane(width: 0.22, height: 0.06)
        space.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "stars_milky_way")
        space.firstMaterial?.isDoubleSided = true
        let spaceNode = SCNNode(geometry: space)
        spaceNode.runAction(SCNAction.rotateBy(x: 0, y: 1.5708, z: 0, duration: 0.0))
        spaceNode.position = SCNVector3(0.11,-0.01,0.01)
        rootNode.addChildNode(spaceNode)
    }
    
    func addBottomSpacePlane() {
        
        let space = SCNPlane(width: 0.22, height: 0.22)
        space.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "stars")
        space.firstMaterial?.isDoubleSided = true
        let spaceNode = SCNNode(geometry: space)
        spaceNode.runAction(SCNAction.rotateBy(x: 1.5708, y: 0, z: 0, duration: 0.0))
        spaceNode.position = SCNVector3(0,-0.04,0.01)
        rootNode.addChildNode(spaceNode)
    }
    
    func addSun() {
        
        let sun = SCNSphere(radius: 1)
        sun.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "sun")
        
        let sunNode = SCNNode(geometry: sun)
        sunNode.scale = SCNVector3(0.01,0.01,0.01)
        sunNode.position = SCNVector3(0,-0.01,-0)
        
        let sunLight = SCNLight()
        sunLight.color = UIColor(red: 255.0/255.0, green: 160.0/255.0, blue: 45.0/255.0, alpha: 1.0).cgColor
        sunLight.type = .omni
        sunLight.temperature = 10000
        sunLight.intensity = 50000.0
        sunLight.categoryBitMask = 0x1 << 1
        
        sunNode.light = sunLight
        sunNode.opacity = 1.0
        
        self.sunNode = sunNode
        sunNode.categoryBitMask = 0x1 << 2
        
        
        rootNode.addChildNode(sunNode)
        
    }
    
    func addMercury() {
        
        let mercury = SCNSphere(radius: 0.1)
        //earth.firstMaterial?.diffuse.contents = UIColor(red: 45.0/255.0, green: 160.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        mercury.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "mercury")
        mercury.firstMaterial?.locksAmbientWithDiffuse = false
        mercury.firstMaterial?.ambient.contents = UIColor.black
        
        let mercuryNode = SCNNode(geometry: mercury)
        mercuryNode.position = SCNVector3(-1.6,0,0)
        
        mercuryNode.categoryBitMask = 0x1 << 1
        
        rotateBody(body: mercuryNode)
        
        revolveAroundSun(body:mercuryNode)
        
        addMercuryRevolutionPath()
    }
    
    func addMercuryRevolutionPath() {
        
        let mercuryPath = SCNTorus(ringRadius: 1.6, pipeRadius: 0.005)
        mercuryPath.firstMaterial?.diffuse.contents = UIColor.white
        
        let pathNode = SCNNode(geometry: mercuryPath)
        
        pathNode.categoryBitMask = 0x1 << 2
        
        revolveAroundSun(body: pathNode)
    }
    
    func addVenus() {
        
        let venus = SCNSphere(radius: 0.15)
        //earth.firstMaterial?.diffuse.contents = UIColor(red: 45.0/255.0, green: 160.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        venus.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "venus")
        venus.firstMaterial?.locksAmbientWithDiffuse = false
        venus.firstMaterial?.ambient.contents = UIColor.black
        
        let venusNode = SCNNode(geometry: venus)
        venusNode.position = SCNVector3(0,0,-2)
        
        venusNode.opacity = 1.0
        venusNode.categoryBitMask = 0x1 << 1
        
        rotateBody(body: venusNode)
        
        revolveAroundSun(body:venusNode)
        
        addVenusRevolutionPath()
    }
    
    func addVenusRevolutionPath() {
        
        let venusPath = SCNTorus(ringRadius: 2.0, pipeRadius: 0.005)
        venusPath.firstMaterial?.diffuse.contents = UIColor.white
        
        let pathNode = SCNNode(geometry: venusPath)
        
        pathNode.categoryBitMask = 0x1 << 2
        
        revolveAroundSun(body: pathNode)
    }
    
    func addEarth() {
        
        let earth = SCNSphere(radius: 0.25)
        //earth.firstMaterial?.diffuse.contents = UIColor(red: 45.0/255.0, green: 160.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        earth.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "earth_1")
        earth.firstMaterial?.locksAmbientWithDiffuse = false
        earth.firstMaterial?.ambient.contents = UIColor.black

        
        let earthNode = SCNNode(geometry: earth)
        earthNode.position = SCNVector3(0,0,3)
        
        earthNode.opacity = 1.0
        earthNode.categoryBitMask = 0x1 << 1
        
        self.earthNode = earthNode
        
        rotateBody(body: earthNode)
        
        revolveAroundSun(body:earthNode)
        
        addEarthsRevolutionPath()
    }
    
    func addEarthsRevolutionPath() {
        
        let earthPath = SCNTorus(ringRadius: 3.0, pipeRadius: 0.005)
        earthPath.firstMaterial?.diffuse.contents = UIColor.white
        
        let pathNode = SCNNode(geometry: earthPath)
        
        pathNode.categoryBitMask = 0x1 << 2
        
        revolveAroundSun(body: pathNode)
    }
    
    func addMars() {
        
        let mars = SCNSphere(radius: 0.125)
        mars.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "mercury")
        mars.firstMaterial?.locksAmbientWithDiffuse = false
        mars.firstMaterial?.ambient.contents = UIColor.black
        
        let marsNode = SCNNode(geometry: mars)
        marsNode.position = SCNVector3(3,0,-1.99)
        
        marsNode.categoryBitMask = 0x1 << 1
        
        rotateBody(body: marsNode)
        
        revolveAroundSun(body:marsNode)
        
        addMarsRevolutionPath()
    }
    
    func addMarsRevolutionPath() {
        
        let marsPath = SCNTorus(ringRadius: 3.6, pipeRadius: 0.005)
        marsPath.firstMaterial?.diffuse.contents = UIColor.white
        
        let pathNode = SCNNode(geometry: marsPath)
        
        pathNode.categoryBitMask = 0x1 << 2
        
        revolveAroundSun(body: pathNode)
    }
    
    func addJupiter() {
        
        let jupiter = SCNSphere(radius: 0.5)
        jupiter.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "jupiter")
        jupiter.firstMaterial?.locksAmbientWithDiffuse = false
        jupiter.firstMaterial?.ambient.contents = UIColor.black
        
        let jupiterNode = SCNNode(geometry: jupiter)
        jupiterNode.position = SCNVector3(4,0,3)
        
        jupiterNode.categoryBitMask = 0x1 << 1
        
        rotateBody(body: jupiterNode)
        
        revolveAroundSun(body:jupiterNode)
        
        addJupiterRevolutionPath()
    }
    
    func addJupiterRevolutionPath() {
        
        let jupiterPath = SCNTorus(ringRadius: 5, pipeRadius: 0.005)
        jupiterPath.firstMaterial?.diffuse.contents = UIColor.white
        
        let pathNode = SCNNode(geometry: jupiterPath)
        
        pathNode.categoryBitMask = 0x1 << 2
        
        revolveAroundSun(body: pathNode)
    }
    
    func addSaturn() {
        
        let saturn = SCNSphere(radius: 0.4)
        saturn.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "saturn")
        saturn.firstMaterial?.locksAmbientWithDiffuse = false
        saturn.firstMaterial?.ambient.contents = UIColor.black
        
        let saturnNode = SCNNode(geometry: saturn)
        saturnNode.position = SCNVector3(-5,0,4.301)
        
        saturnNode.categoryBitMask = 0x1 << 1
        
        addSaturnsRings(saturn: saturnNode)
        rotateBody(body: saturnNode)
        
        revolveAroundSun(body:saturnNode)
        
        addSaturnRevolutionPath()
    }
    
    func addSaturnsRings(saturn: SCNNode) {
        
        let ring = SCNTorus(ringRadius: 0.65, pipeRadius: 0.01)
        ring.firstMaterial?.diffuse.contents = UIColor.white
        
        ring.pipeSegmentCount = 4
        let ringNode = SCNNode(geometry: ring)
        ringNode.scale = SCNVector3(1.25,0.5,1.15)
        
        ringNode.categoryBitMask = 0x1 << 2
        
        saturn.addChildNode(ringNode)
    }
    
    func addSaturnRevolutionPath() {
        
        let saturnPath = SCNTorus(ringRadius: 6.6, pipeRadius: 0.005)
        saturnPath.firstMaterial?.diffuse.contents = UIColor.white
        
        let pathNode = SCNNode(geometry: saturnPath)
        
        pathNode.categoryBitMask = 0x1 << 2
        
        revolveAroundSun(body: pathNode)
    }
    
    func addUranus() {
        
        let uranus = SCNSphere(radius: 0.285)
        uranus.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "uranus")
        uranus.firstMaterial?.locksAmbientWithDiffuse = false
        uranus.firstMaterial?.ambient.contents = UIColor.black
        
        let uranusNode = SCNNode(geometry: uranus)
        uranusNode.position = SCNVector3(-6,0,-4.665)
        
        uranusNode.categoryBitMask = 0x1 << 1
        
        rotateBody(body: uranusNode)
        
        revolveAroundSun(body:uranusNode)
        
        addUranusRevolutionPath()
    }
    
    func addUranusRevolutionPath() {
        
        let uranusPath = SCNTorus(ringRadius: 7.6, pipeRadius: 0.005)
        uranusPath.firstMaterial?.diffuse.contents = UIColor.white
        
        let pathNode = SCNNode(geometry: uranusPath)
        
        pathNode.categoryBitMask = 0x1 << 2
        
        revolveAroundSun(body: pathNode)
    }
    
    func addNeptune() {
        
        let neptune = SCNSphere(radius: 0.265)
        neptune.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "neptune")
        neptune.firstMaterial?.locksAmbientWithDiffuse = false
        neptune.firstMaterial?.ambient.contents = UIColor.black
        
        let neptuneNode = SCNNode(geometry: neptune)
        neptuneNode.position = SCNVector3(8.5,0,0)
        
        neptuneNode.categoryBitMask = 0x1 << 1
        
        rotateBody(body: neptuneNode)
        
        revolveAroundSun(body: neptuneNode)
        
        addNeptuneRevolutionPath()
    }
    
    func addNeptuneRevolutionPath() {
        
        let uranusPath = SCNTorus(ringRadius: 8.5, pipeRadius: 0.005)
        uranusPath.firstMaterial?.diffuse.contents = UIColor.white
        
        let pathNode = SCNNode(geometry: uranusPath)
        
        pathNode.categoryBitMask = 0x1 << 2
        
        revolveAroundSun(body: pathNode)
    }
    
    func addPluto() {
        
        let pluto = SCNSphere(radius: 0.089)
        pluto.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "pluto")
        pluto.firstMaterial?.locksAmbientWithDiffuse = false
        pluto.firstMaterial?.ambient.contents = UIColor.black
        
        let plutoNode = SCNNode(geometry: pluto)
        plutoNode.position = SCNVector3(-9.4,0,0)
        
        plutoNode.categoryBitMask = 0x1 << 1
        
        rotateBody(body: plutoNode)
        
        revolveAroundSun(body: plutoNode)
        
        addPlutoRevolutionPath()
    }
    
    func addPlutoRevolutionPath() {
        
        let uranusPath = SCNTorus(ringRadius: 9.4, pipeRadius: 0.005)
        uranusPath.firstMaterial?.diffuse.contents = UIColor.white
        
        let pathNode = SCNNode(geometry: uranusPath)
        
        pathNode.categoryBitMask = 0x1 << 2
        
        revolveAroundSun(body: pathNode)
    }
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
       
        // retrieve the SCNView
        if (rootIsSet) {
            let scnView = self.view as! SCNView
            
            // check what nodes are tapped
            let p = gestureRecognize.location(in: scnView)
            let hitResults = scnView.hitTest(p, options: [:])
            // check that we clicked on at least one object
            if hitResults.count > 0 {
                // retrieved the first clicked object
                let result = hitResults[0]
                
                if result.node == self.sunNode {
                    makeSunGlow()
                }
            }
        } else {
            if (featurePointFound) {
                
                let tapLocation = sceneView.center
                let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)

                if hitTestResultsWithFeaturePoints.first != nil {
                    
                    let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first!
                    
                    stopFeaturePointScan()
                    featurePointFound = false
                    
                    let translation = hitTestResultWithFeaturePoints.worldTransform.translation
                    self.rootIsSet = true
                    print(translation.x,translation.y,translation.z)
                    createRoot(x: translation.x, y: translation.y, z: translation.z)
                    removeIntroduction()
                    updateFeatureFoundDesctionLabel(text: "Tap The Sun To Rotate The Solar System")
                    
                }
            }
        }
    }
    
    func checkFeaturePointsAtCenterScreen() {
        
        let centerLocation = sceneView.center
        let hitTestResultsWithFeaturePoints = sceneView.hitTest(centerLocation, types: .featurePoint)
        
        if hitTestResultsWithFeaturePoints.first != nil {
            
            print("Feature points found")
            featureFoundIndicatorSquare?.isHidden = true
            updateFeatureFoundDesctionLabel(text: "Tap The Screen Where You Would Like To Place The Solar System")
            featurePointFound = true
            featureFoundIndicatorSquare?.layer.removeAllAnimations()
            
        } else {
            print("Could NOT find feature points")
            featureFoundIndicatorSquare?.isHidden = false
            updateFeatureFoundDesctionLabel(text: "For Best Results Point Camera At A Flat Surface Then Slowly Move Camera Closer To Then Further Away From The surface Until The Square Disapears")
            featurePointFound = false
        }
    }
    
    func addMainLight() {
        
        let mainLight = SCNLight()
        mainLight.type = .ambient
        mainLight.intensity = 1000.0
        mainLight.categoryBitMask = 0x1 << 2
        
        sceneView.scene.rootNode.light = mainLight
    }
    
    func makeSunGlow() {
        
        if (featureFindingDescriptionLabel != nil) {
            
            featureFindingDescriptionLabel?.removeFromSuperview()
            featureFindingDescriptionLabel = nil
        }
        
        let material = sunNode.geometry!.firstMaterial!
        
        // highlight it
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5
        
        // on completion - unhighlight
        SCNTransaction.completionBlock = {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            material.emission.contents = UIColor.black
            
            SCNTransaction.commit()
            self.rotateSun()
        }
        
        material.emission.contents = UIColor.red
        
        SCNTransaction.commit()
    }
    
    func rotateSun() {

        if(sunIsSpinning) {
            
            sunNode.removeAction(forKey: "myrotate")
            sunIsSpinning = false
        } else {
            
            let action = SCNAction.rotateBy(x: 0, y: CGFloat(2 * Double.pi), z: 0, duration: 7)
            let repAction = SCNAction.repeatForever(action)
            sunNode.runAction(repAction, forKey: "myrotate")
            sunIsSpinning = true
        }
    }
    
    func rotateBody(body: SCNNode) {
        
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(2 * Double.pi), z: 0, duration: 5)
        let repAction = SCNAction.repeatForever(action)
        body.runAction(repAction, forKey: "myrotate")        
    }
    
    func revolveAroundSun(body: SCNNode) {
        
        sunNode.addChildNode(body)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

import { useEffect } from "react"
import { preconnect } from "react-dom"
import * as THREE from "three"
import { PointerLockControls } from 'three/examples/jsm/controls/PointerLockControls'
import { VRButton } from "three/addons/webxr/VRButton.js"

export default function Index() {
  let players = {}
  let canvas
  let room
  
  async function created() {
    const ActionCable = await import('actioncable')
    const cable = ActionCable.createConsumer(process.env.NEXT_PUBLIC_WSNAME)
    room = cable.subscriptions.create("WorldChannel", {
      connected() {
        console.log('Connected to World.')
      },
      disconnected() {
        console.log('Disconnected from World.')
      },
      received(data) {
        console.log('Data received.', data)
      },
      speak: function (data) {
        return this.perform('move', { 'position': data });
      }
    })
  }

  useEffect(() => {
    created()
    canvas = document.getElementById('canvas')
    const sizes = {
      width: innerWidth,
      height: innerHeight
    }
    // 宣言
    let moveForward = false
    let moveBackward = false
    let moveLeft = false
    let moveRight = false

    const velocity = new THREE.Vector3()
    const direction = new THREE.Vector3()

    const color = new THREE.Color();
    // シーン
    const scene = new THREE.Scene()
    scene.background = new THREE.Color(0xffffff);
    scene.fog = new THREE.Fog(0xffffff, 0, 750);

    // カメラ
    const camera = new THREE.PerspectiveCamera(
      75,
      sizes.width / sizes.height,
      0.1,
      1000
    )
    camera.position.set(0, 1, 2)

    // レンダラー
    const renderer = new THREE.WebGLRenderer({
      canvas: canvas,
      antialias: true,
    })
    renderer.setSize(sizes.width, sizes.height)
    renderer.setPixelRatio(window.devicePixelRatio)
    renderer.xr.enabled = true

    // ライト
    const light = new THREE.HemisphereLight(0xeeeeff, 0x777788, 0.75);
    light.position.set(0.5, 1, 0.75);
    scene.add(light);

    // FPS視点設定
    const controles = new PointerLockControls(camera, renderer.domElement)
    window.addEventListener('click', () => {
      controles.lock()
    })

    // オブジェクト
    const planeGeometry = new THREE.PlaneGeometry(400, 400, 100, 100);
    const material = new THREE.MeshBasicMaterial({
      color: "orange",
      wireframe: true,
    });
    const plane = new THREE.Mesh(planeGeometry, material);
    plane.rotateX(-Math.PI / 2);
    scene.add(plane);

    const boxGeometry = new THREE.BoxGeometry(20, 20, 20);
    let position = boxGeometry.attributes.position;
    const colorsBox = [];
    for (let i = 0, l = position.count; i < l; i++) {
      color.setHSL(Math.random() * 0.3 + 0.5, 0.75, Math.random() * 0.25 + 0.75);
      colorsBox.push(color.r, color.g, color.b);
    }
    boxGeometry.setAttribute(
      "color",
      new THREE.Float32BufferAttribute(colorsBox, 3)
    );
    for (let i = 0; i < 200; i++) {
      const boxMaterial = new THREE.MeshPhongMaterial({
        specular: 0xffffff,
        flatShading: true,
        vertexColors: true,
      });
      boxMaterial.color.setHSL(
        Math.random() * 0.2 + 0.5,
        0.75,
        Math.random() * 0.25 + 0.75
      );
      const box = new THREE.Mesh(boxGeometry, boxMaterial);
      box.position.x = Math.floor(Math.random() * 20 - 10) * 20;
      box.position.y = Math.floor(Math.random() * 20) * 20 + 10;
      box.position.z = Math.floor(Math.random() * 20 - 10) * 20;
      scene.add(box);
    }
    /*
    const geometry = new THREE.BoxGeometry( 1, 1, 1 ); 
    const material = new THREE.MeshBasicMaterial( {color: 0x00ff00} ); 
    const cube = new THREE.Mesh( geometry, material ); 
    scene.add( cube );
    */
    const sendPosition = () => {
      player = {
        x: Math.round(camera.position.x * 100) / 100,
        y: Math.round(camera.position.y * 100) / 100,
        z: Math.round(camera.position.z * 100) / 100
      }
      room.speak({
        x: player.x,
        y: player.y,
        z: player.z
      })
      console.log(`send ${player.x}`)
    }
    // キーボード操作
    const onKeyDown = (e) => {
      switch (e.keyCode) {
        case 87:
          moveForward = true
          break
        case 65:
          moveLeft = true
          break
        case 83:
          moveBackward = true
          break
        case 68:
          moveRight = true
          break
        case 70:
          sendPosition()
          break
      }
    }
    const onKeyUp = (e) => {
      switch (e.keyCode) {
        case 87:
          moveForward = false
          break
        case 65:
          moveLeft = false
          break
        case 83:
          moveBackward = false
          break
        case 68:
          moveRight = false
          break
      }
    }
    document.addEventListener('keydown', onKeyDown)
    document.addEventListener('keyup', onKeyUp)
    let prevTime = performance.now()
    let countDelta = 0
    let player = {}

    function animate() {
      //requestAnimationFrame(animate);

      const time = performance.now()
      const delta = (time - prevTime) / 1000
      countDelta += delta * 1000
      if (countDelta >= 100) {
        //sendPosition()
        countDelta = 0
      }

      // 前進後進判定
      direction.z = Number(moveForward) - Number(moveBackward)
      direction.x = Number(moveRight) - Number(moveLeft)

      //ポインターがONになったら
      if (controles.isLocked) {

        // 減衰
        velocity.z -= velocity.z * 5.0 * delta
        velocity.x -= velocity.x * 5.0 * delta
        if (moveForward || moveBackward) {
          velocity.z -= direction.z * 200 * delta
        }
        if (moveRight || moveLeft) {
          velocity.x -= direction.x * 200 * delta
        }
        controles.moveForward(-velocity.z * delta)
        controles.moveRight(-velocity.x * delta)
      }
      prevTime = time
      renderer.render(scene, camera);
    }
    
    renderer.setAnimationLoop(animate)
    document.body.appendChild(VRButton.createButton(renderer));


    // 画面リサイズ設定
    window.addEventListener("resize", onWindowResize);
    function onWindowResize() {
      camera.aspect = window.innerWidth / window.innerHeight;
      camera.updateProjectionMatrix();
      renderer.setSize(window.innerWidth, window.innerHeight);
    }
  }, [])
  return (
    <>
      <canvas id='canvas'></canvas>
      <p>test</p>
    </>
  )
}
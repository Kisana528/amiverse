import React, { useRef, useEffect } from 'react'

export default function Canvas() {
  const canvasRef = useRef(null)
  useEffect(() => {
    const canvas = canvasRef.current
    const context = canvas.getContext('2d')
    let isDrawing = false
    let lastX = 0
    let lastY = 0
    function draw(event) {
      if (!isDrawing) return
      let x, y
      if (event.type === 'mousemove') {
        x = event.offsetX
        y = event.offsetY
      } else if (event.type === 'touchmove') {
        const touch = event.touches[0]
        const rect = canvas.getBoundingClientRect()
        x = touch.clientX - rect.left
        y = touch.clientY - rect.top
      }
      context.beginPath()
      //context.arc(x, y, .1, 0, Math.PI * 2);
      //context.fillStyle = "lightskyblue";
      //context.fill();
      context.moveTo(lastX, lastY)
      context.lineTo(x, y)
      context.stroke()
      lastX = x
      lastY = y
    }
    canvas.addEventListener('mousedown', (e) => {
      isDrawing = true;
      [lastX, lastY] = [e.offsetX, e.offsetY];
      context.fillRect(lastX, lastY, 1, 1);
    });
    canvas.addEventListener('touchstart', (e) => {
      e.preventDefault()
      isDrawing = true
      const rect = canvas.getBoundingClientRect()
      lastX = e.touches[0].clientX - rect.left
      lastY = e.touches[0].clientY - rect.top
      context.fillRect(lastX, lastY, 1, 1)
    })
    canvas.addEventListener('mousemove', draw)
    canvas.addEventListener('touchmove', (e) => {
      e.preventDefault()
      draw(e)
    })
    canvas.addEventListener('mouseup', () => isDrawing = false)
    canvas.addEventListener('touchend', () => isDrawing = false)
    canvas.addEventListener('mouseout', () => isDrawing = false)
    let paths = [];
    function savePath() {
      paths.push(context.getImageData(0, 0, canvas.width, canvas.height))
    }
    function undo() {
      if (paths.length === 0) return
      paths.pop()
      redraw()
    }
    function clearCanvas() {
      context.clearRect(0, 0, canvas.width, canvas.height)
      paths = []
    }
    function redraw() {
      context.clearRect(0, 0, canvas.width, canvas.height)
      paths.forEach((path) => {
        context.putImageData(path, 0, 0)
      })
    }
    function downloadImage() {
      const link = document.createElement("a")
      link.download = "canvas.png"
      link.href = canvas.toDataURL("image/png")
      link.click()
    }
    canvas.addEventListener("mouseup", () => {
      savePath()
    })
    canvas.addEventListener('touchend', () => {
      savePath()
    })
    document.getElementById("undo").addEventListener("click", () => {
      undo()
    })
    document.getElementById("clear").addEventListener("click", () => {
      clearCanvas()
    })
    document.getElementById("download").addEventListener("click", () => {
      downloadImage()
    })
  }, [])

  return (
    <>
      <button id="undo">undo</button>
      <button id="clear">clear</button>
      <button id="download">download</button>
      <br />
      <canvas
        ref={canvasRef}
        width={320}
        height={120}
        style={{ border: '1px solid black' }}
      />
    </>
  )
}
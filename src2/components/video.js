import { useRef } from 'react'
import Hls from 'hls.js'

export default function Video({ videoUrl }) {
  
  const videoRef = useRef(null)
  const video = videoRef.current
  const videoSrc = videoUrl

  if (Hls.isSupported()) {
    const hls = new Hls()
    hls.loadSource(videoSrc)
    hls.attachMedia(video)
  }

  return (
    <>
      <div className="video-view" >
          <video ref={videoRef} controls />
      </div>
      <style jsx>{`
        .main-container {
          background: var(--main-container-background-color);
          padding: 5px;
        }
      `}</style>
    </>
  )
}
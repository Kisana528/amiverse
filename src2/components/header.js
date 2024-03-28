import Link from 'next/link'
import React, { useContext } from 'react'
import { appContext } from '@/pages/_app'

export default function Header() {
  const darkThreme = useContext(appContext).darkThreme
  const darkThremeTrigger = useContext(appContext).darkThremeTrigger

  return (
    <header>
      <div className="top">
        <Link href="/">
          <div className="top-inner">
            Amiverse
          </div>
        </Link>
      </div>
      <div className="mode-toggle">
        <button className={darkThreme ? "dark-button" : "light-button"} onClick={darkThremeTrigger}>{darkThreme ? "🌙" : "☀️"}</button>
      </div>
      <style jsx>{`
      header {
        z-index: 8;
        display: flex;
        position: sticky;
        top: 0;
        width: 100%;
        height: 60px;
        background-color: rgb(186, 255, 232);
        align-items: center;
        justify-content: center;
      }
      .top {

      }
      .top-inner {
        line-height: 60px;
        padding: 0 10px;
      }
      .mode-toggle {
        height: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
      }
      .dark-button{
        width: 30px;
        height: 30px;
        border: 3px solid #fff;
        background: #395391;
        margin: auto;
        border-radius: 15px;
      }
      .light-button{
        width: 30px;
        height: 30px;
        border: 3px solid #000;
        background: #fff9cb;
        margin: auto;
        border-radius: 15px;
      }
      `}</style>
    </header>
  )
}
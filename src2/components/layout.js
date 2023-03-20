import Header from './header'
import Footer from './footer'
import Nav from './nav'
import Tab from './tab'
import { appContext } from '@/pages/_app'
import React, { useState, useEffect, useContext } from 'react'

export default function Layout({ children }) {
  const loading = useContext(appContext).loading
  const loadingStatus = useContext(appContext).loadingStatus
  const dark = useContext(appContext).dark
  const flash = useContext(appContext).flash
  const setFlash = useContext(appContext).setFlash
  const handleClick = () => {
    setFlash('')
  }

  return (
    <div className={`all ${dark ? "dark-mode" : "light-mode"} ${loading ? "loading-top" : ""}`}>
      <div className={`loading-hide ${loading ? "loading" : ""}`}>
        <div className="loading-logo">Amiverse</div>
        <div className="loading-status">{loadingStatus}</div>
      </div>
      <Header />
      <div className="main-container">
        <Nav />
        <main>
          {children}
          {flash ? <div className="flash" onClick={handleClick}>{flash}</div> : ''}
        </main>
        <Tab />
      </div>
      <style jsx="true">{`
        .all {
          background: var(--background-color);
          color: var(--font-color);
        }
        .loading-top {
          width: 100vw;
          height: 100vh;
          overflow: hidden;
        }
        .loading-hide {
          display: none;
        }
        .loading {
          z-index: 10;
          display: flex;
          align-items: center;
          justify-content: center;
          flex-direction: column;
          position: fixed;
          top: 0;
          left: 0;
          width: 100vw;
          height: 100vh;
          background: rgb(22,22,22);
        }
        .loading-logo {
          font-size: 50px;
          font-family: math;
          color: #b057e8;
        }
        .loading-status {
          color: #64a5fc;
        }
        main {
          //height: 300vh;
          //background-color: rgb(209, 233, 255);
          flex-grow: 1;
        }
        .main-container {
          display: flex;
        }
        .flash {
          border: 1px solid #000;
          border-radius: 5px;
          padding: 3px;
          position: fixed;
          right: 10px;
          background-color: #4fff67bb;
          bottom: 70px;
          z-index: 200;
        }
      `}</style>
    </div>
  )
}
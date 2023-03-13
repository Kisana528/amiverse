import Header from './header'
import Footer from './footer'
import Nav from './nav'
import Tab from './tab'
import React, { useState, useEffect } from 'react'

export default function Layout({ children, isDark }) {
  return (
    <div className={`all ${isDark ? "dark" : ""}`}>
      <Header />
      <div className="main-container">
        <Nav />
        <main>{children}</main>
        <Tab />
      </div>
      <style jsx="true">{`
        .all {
        }
        .dark {
          background-color: #000000e6;
          color: #fff;
        }
        main {
          height: 300vh;
          //background-color: rgb(209, 233, 255);
          flex-grow: 1;
        }
        .main-container {
          display: flex;
        }
      `}</style>
    </div>
  )
}
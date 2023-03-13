import Link from 'next/link'
import React, {useContext} from 'react'
import {appContext} from '../pages/_app'

export default function Tab() {
  const isDark = useContext(appContext).isDark
  const modeTrigger = useContext(appContext).modeTrigger
  return (
    <div className="tab">
      <p>content here</p>
      <button onClick={modeTrigger}>{isDark ? '🌙' : '☀'}</button>
      <style jsx="true">{`
        .tab {
          display: none;
        }
         @media (min-width: 600px) {
          .tab {
            display: inline-block;
          }
        }
      `}</style>
    </div>
  )
}
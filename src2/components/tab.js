import React, { useContext } from 'react'
import { appContext } from '@/pages/_app'
import Logout from './logout'

export default function Tab() {
  const isDark = useContext(appContext).isDark
  const loggedIn = useContext(appContext).loggedIn
  const setLoggedIn = useContext(appContext).setLoggedIn
  const modeTrigger = useContext(appContext).modeTrigger

  return (
    <div className="tab">
      <p>content here</p>
      <button onClick={modeTrigger}>{isDark ? '🌙' : '☀'}</button>
      <Logout />
      <style jsx="true">{`
        .tab {
          display: none;
        }
        @media (min-width: 600px) {
          /* tab2 */
          .tab {
            display: inline-block;
          }
        }
      `}</style>
    </div>
  )
}
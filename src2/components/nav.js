import Link from 'next/link'

export default function Nav() {
  return (
    <nav>
      <ul>
        <li>1</li>
        <li>2</li>
        <li>3</li>
        <li>4</li>
      </ul>
      <style jsx="true">{`
        /* 2 */
        nav {
          //background-color: rgb(212, 166, 255);
          height: calc(100vh - 60px);
          position: sticky;
          top: 60px;
        }
        nav ul {
          margin: 0px;
          padding: 0px;
          display: flex;
          
          flex-direction: column;
          height: 100%;
        }
        nav ul li {
          display: inline-block;
          width: 30px;
          height: 30px;
          background-color: rgb(254, 207, 149);
        }
        @media (max-width: 400px) {
          nav {
          /* 1 */
          position: fixed;
          top: auto;
          bottom: 0;
          width: 100%;
          height: 30px;
          }
          nav ul {
            flex-direction: row;
            justify-content: space-around;
          }
        }
        @media (min-width: 700px) {
          /* 3 */
          nav ul li {
            width: 100px;
          }
        }
      `}</style>
    </nav>
  )
}
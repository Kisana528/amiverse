import Link from 'next/link'

export default function Item({ item }) {

  return (
    <>
      <div className="item">
        <div className="item-content">
          {item.content}
        </div>
        <div className="item-reaction">
          <button>💖</button>
          <div>11</div>
          <button>🍭</button>
          <div>4</div>
          <button>➕</button>
          <div>‥</div>
          <button>🔃</button>
          <div>5</div>
        </div>
      </div>
      <style jsx>{`
        .item {
          padding: 10px 5px;
          border-bottom: 1px var(--border-color) solid;
          //display: flex;
        }
        .item-content {
          min-height: 40px;
          padding: 5px;
          overflow-wrap: break-word;
        }
        .item-reaction {
          display: flex;
          padding: 4px;
        }
      `}</style>
    </>
  )
}
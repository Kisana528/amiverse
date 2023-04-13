import Link from 'next/link'

export default function Item({ item }) {

  return (
    <>
      <div className="item">
        <div className="item-content">
          {item.content}
        </div>
        {item.images && item.images.length > 0 ?
          item.images.map(image => (
            <div key={image.image_id}>
              <img src={image.url} className="item-image"></img>
            </div>
          ))
        :
          <div>のいまげ</div>
        }
        <div className="item-reaction">
          {item.reactions.map(reaction => (
            <div key={reaction.reaction_id}>
              <button>{reaction.content}</button>
              <div>{reaction.count}</div>
            </div>
          ))}
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
          flex-wrap: wrap;
        }
        .item-image {
          width: 100%
        }
      `}</style>
    </>
  )
}
import Link from 'next/link'

export default function ItemAccount({ item }) {

  return (
    <>
      <div className="item">
        <Link href={'/@' + item.account.name_id}>
          <div className="item-whose">
            <img
              src={item.account.icon_url}
              className="item_account_image"
            />
            <div className="item-account">
              <div className="item-account-profile">
                <div className="item-account-name">
                  {item.account.name}
                </div>
                <div className="item-account-name-id">
                  {'@' + item.account.name_id}
                </div>
              </div>
              {/* menu */}
            </div>
          </div>
        </Link>
        <div className="item-content">
          {item.content}
        </div>
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
        .item-whose {
          display: flex;
          padding: 4px;
        }
        .item_account_image{
          border-radius: 24px;
          height: 48px;
          aspect-ratio: 1/1;
          box-shadow: 2px 4px 8px 0px var(--shadow-color);
          object-fit: cover;
          object-position: top center;
          background: linear-gradient(90deg,#747eee,#d453cc 50%,#fe5597);
        }
        .item-account {
          margin-left: 8px;
        }
        .item-account-profile {
          display: flex;
          flex-direction: column;
        }
        .item-account-name {
          font-size: 24px;
          line-height: 30px;
        }
        .item-account-name-id {
          line-height: 18px;
          font-size: 16px;
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
      `}</style>
    </>
  )
}
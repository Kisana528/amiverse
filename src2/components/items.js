import Link from 'next/link'
import ItemAccount from '@/components/item_account'

export default function Items({ items = [], loadItems = false }) {

  return (
    <>
      <div className="items">
        {(() => {
          if (loadItems) {
            return <p>Loading...</p>;
          } else if (items.length > 0) {
            return items.map(item => (
              <ItemAccount key={item.aid} item={item} />
            ));
          } else {
            return <p>Nothing Here</p>;
          }
        })()}
      </div>
      <style jsx>{`
        .item {
        }
      `}</style>
    </>
  )
}
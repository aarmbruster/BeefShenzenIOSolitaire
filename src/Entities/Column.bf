using System;
using System.Collections;
using Atma;
using Atma.Entities.Components;

namespace BeefShenzenIOSolitaire.Entities
{
	public class Column:  Entity
	{
		public static List<Column> columns = new List<Column>() ~ delete _;
		public List<Card> cards = new List<Card>() ~ delete _;

		public CollisionComponent collision;

		public Sprite sprite;

		public this()
		{
			collision = Components.Add(new CollisionComponent(true));
			collision.LocalBounds = aabb2.FromDimensions(float2(0.0f, 0.0f), float2(122.0f, 237.0f));
			sprite = Components.Add(new Sprite(Core.Atlas["main/card_back"]));
			this.SetDepth(255);
		}

		public static void AddColumn(Column in_column)
		{
			columns.Add(in_column);
		}

		public void AddCard(Card in_card)
		{
			if(cards.Count > 0)
			{
				cards.Back.SetChild(in_card);
			}
			
			collision.LocalBounds = in_card.collision.LocalBounds;
			collision.DebugRender();
			cards.Add(in_card);
			in_card.Depth = CardManager.scd() + cards.Count;
			this.Depth = in_card.Depth + 1;
			this.Position = in_card.Position;
			
		}
		public void RemoveCard(Card in_card)
		{
			cards.Remove(in_card);
			this.Position = float2(this.Position.x, CardManager.column_y + (cards.Count) * 36 + collision.LocalBounds.Height / 2);
			Console.WriteLine("Column Position: {}", this.Position);	
			
		}

		protected override void OnUpdate()
		{
			base.OnUpdate();
			collision.DebugRender();
		}
	}
}
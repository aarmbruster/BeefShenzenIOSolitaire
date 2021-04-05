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

		protected override void OnUpdate()
		{
			base.OnUpdate();
			collision.DebugRender();
		}
	}
}

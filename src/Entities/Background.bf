using Atma;
using System;

namespace BeefShenzenIOSolitaire.Entities
{
	public class Background : Entity
	{
		private Sprite sprite;

		public this() : base("Background")
		{
			sprite = Components.Add(new Sprite(Core.Atlas["main/table_large"]));
			sprite.X = Screen.Width / 2;
			sprite.Y = Screen.Height / 2;
		}
	}
}

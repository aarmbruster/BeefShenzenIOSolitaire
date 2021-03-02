using Atma;

namespace BeefShenzenIOSolitaire.Entities
{
	public class SpecialButton : Entity
	{
		private Sprite down;
		private Sprite up;
		private Sprite active;

		public this(Subtexture texture, float2 pos) : base ("Button")
		{
			up = Components.Add(new Sprite(texture));
			Position = pos;
		}
	}
}

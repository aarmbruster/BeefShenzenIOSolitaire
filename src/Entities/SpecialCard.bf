using Atma;

namespace BeefShenzenIOSolitaire.Entities
{
	public class SpecialCard : Card
	{
		public this(BaseCardInfo card_info) : base (card_info)
		{
			if(card_info.card_type == .Green)
			{
				card_indicator.Tint = Colors.Green;
			}

			top_indicator = Components.Add(GetCardIndicator(card_info.card_type));
			top_indicator.X = -45;
			top_indicator.Y = -96;
			top_indicator.SetDepth(0.3f);
			bottom_indicator = Components.Add(GetCardIndicator(card_info.card_type));
			bottom_indicator.X = 45;
			bottom_indicator.Y = 96;
			bottom_indicator.SetDepth(0.3f);
			bottom_indicator.SpriteRotation = 0.5f;

			if(card_info.card_type == .Green)
			{
				top_indicator.Tint = Colors.Green;
				bottom_indicator.Tint = Colors.Green;
			}
		}

		public override Sprite GetCardIndicator(CardType in_card_type)
		{
			if(in_card_type == .White)
			{
				return new Sprite(Core.Atlas["main/dragon_white_sm"]);
			}
			else if (in_card_type == .Red)
			{
				return new Sprite(Core.Atlas["main/dragon_red_sm"]);
			}
			else if (in_card_type == .Green)
			{
				return new Sprite(Core.Atlas["main/dragon_green_sm"]);
			}
			else
			{
				return new Sprite(Core.Atlas["main/flower_sm"]);
			}
		}

		public void Resolve()
		{
			SetState(.Resolved);
			card_front.Visible = top_indicator.Visible = bottom_indicator.Visible = card_indicator.Visible = false;
			card_back.Visible = true;
		}

		public override void UpdateState(bool atomic = false)
		{
			if(card_state == .Resolved && !atomic)
				return;

			if(IsParented)
			{
				if(parent.GetCardType() == .Holder)
				{
					CardHolder parent_holder = (CardHolder)parent;
					if(parent_holder.holder_type == .Rose)
					{
						SetState(.Resolved);
					}
						else if(parent_holder.holder_type == .Temp)
					{
						SetState(.Temped);
					}
						else if (parent_holder.holder_type == .Stack)
					{
						SetState(.Stacked);
					}
				}
				else
				{
					SetState(.Stacked);
				}
			}
		}

		public override bool CanBeDroppedOn(Card new_parent)
		{
			if(card_state == .Resolved)
			{
				return false;
			}

			if(new_parent.GetCardType() == .Holder)
			{
				let holder_parent = (CardHolder)new_parent;
				if(holder_parent.holder_type == .Resolved)
				{
					return false;
				}

				if(holder_parent.holder_type != .Rose && this.GetCardType() == .Flower)
				{
					return false;
				}

				if(holder_parent.holder_type == .Rose && this.GetCardType() != .Flower)
				{
					return false;
				}

				return true;
			}

			return false;
		}

		public override float2 GetChildOffset(Card in_child)
		{
			if(card_state == .Resolved)
				return float2.Zero;
			return base.GetChildOffset(in_child);
		}
	}
}

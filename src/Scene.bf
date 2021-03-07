using System;
using System.Collections;
using Atma.Entities.Components;
namespace Atma
{
	public extension Scene
	{
		public readonly List<CollisionComponent> CollisionComponents = new List<CollisionComponent>();

		public ~this()
		{
			delete(CollisionComponents);
		}

		public void RegisterCollision(CollisionComponent collision)
		{
			CollisionComponents.Add(collision);
		}

		public void UnRegisterCollision(CollisionComponent collision)
		{
			CollisionComponents.Remove(collision);
		}
	}
}

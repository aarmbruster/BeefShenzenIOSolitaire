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
			int i = 0;
			for(; i < CollisionComponents.Count; i++)
			{
				if(collision.Entity.Depth >= CollisionComponents[i].Entity.Depth)
				{
					break;
				}
			}
			CollisionComponents.Insert(i, collision);
		}

		public void UnRegisterCollision(CollisionComponent collision)
		{
			CollisionComponents.Remove(collision);
		}
	}
}

﻿using System.Collections.Generic;
using UnityEngine;

public class OoSimpleDecalMeshBuilder
{
	private readonly List<Vector3> _vertices = new List<Vector3>();
	private readonly List<Vector3> _normals = new List<Vector3>();
	private readonly List<Vector2> _texcoords = new List<Vector2>();
	private readonly List<int> _indices = new List<int>();

	//	public void Clear()
	//	{
	//		_vertices.Clear();
	//		_normals.Clear();
	//		_texcoords.Clear();
	//		_indices.Clear();
	//	}

	// builder 是一个 mesh 数据的容器。
	public void Build(
		Transform decalTransform,
		MeshFilter targetMeshFilter,
		float maxClipAngle)
	{
		Matrix4x4 objToDecalMatrix = decalTransform.worldToLocalMatrix * targetMeshFilter.transform.localToWorldMatrix;

		Mesh mesh = targetMeshFilter.sharedMesh;
		Vector3[] vertices = mesh.vertices;
		int[] triangles = mesh.triangles;

		for (int i = 0; i < triangles.Length; i += 3)
		{
			int i1 = triangles[i];
			int i2 = triangles[i + 1];
			int i3 = triangles[i + 2];

			// 把 target mesh 中的点转换到 decal 的本地空间。
			Vector3 v1 = objToDecalMatrix.MultiplyPoint(vertices[i1]);
			Vector3 v2 = objToDecalMatrix.MultiplyPoint(vertices[i2]);
			Vector3 v3 = objToDecalMatrix.MultiplyPoint(vertices[i3]);

			// 把三个点加到 builder 中。
			AddTriangle(v1, v2, v3, maxClipAngle);
		}
	}

	private void AddTriangle(Vector3 v1, Vector3 v2, Vector3 v3, float maxClipAngle)
	{
		//		Rect uvRect = To01(decal.sprite.textureRect, decal.sprite.texture);
		Rect uvRect = new Rect(0, 0, 1, 1);
		Vector3 normal = Vector3.Cross(v2 - v1, v3 - v1).normalized;

		if (Vector3.Angle(Vector3.forward, -normal) <= maxClipAngle)
		{
			var poly = OoSimpleDecalUtility.Clip(v1, v2, v3);
			if (poly.Length > 0)
			{
				AddPolygon(poly, normal, uvRect);
			}
		}
	}

	private void AddPolygon(Vector3[] poly, Vector3 normal, Rect uvRect)
	{
		int ind1 = AddVertex(poly[0], normal, uvRect);

		for (int i = 1; i < poly.Length - 1; i++)
		{
			int ind2 = AddVertex(poly[i], normal, uvRect);
			int ind3 = AddVertex(poly[i + 1], normal, uvRect);

			_indices.Add(ind1);
			_indices.Add(ind2);
			_indices.Add(ind3);
		}
	}

	private int AddVertex(Vector3 vertex, Vector3 normal, Rect uvRect)
	{
		int index = FindVertex(vertex);
		if (index == -1)
		{
			_vertices.Add(vertex);
			_normals.Add(normal);
			AddTexcoord(vertex, uvRect);
			return _vertices.Count - 1;
		}
		else
		{
			_normals[index] = (_normals[index] + normal).normalized;
			return index;
		}
	}

	private int FindVertex(Vector3 vertex)
	{
		for (int i = 0; i < _vertices.Count; i++)
		{
			if (Vector3.Distance(_vertices[i], vertex) < 0.01f) return i;
		}
		return -1;
	}

	private void AddTexcoord(Vector3 ver, Rect uvRect)
	{
		float u = Mathf.Lerp(uvRect.xMin, uvRect.xMax, ver.x + 0.5f);
		float v = Mathf.Lerp(uvRect.yMin, uvRect.yMax, ver.y + 0.5f);
		_texcoords.Add(new Vector2(u, v));
	}

	// 让每一个顶点沿着法线方向外展
	public void Push(float distance)
	{
		for (int i = 0; i < _vertices.Count; i++)
		{
			_vertices[i] += _normals[i] * distance;
		}
	}

	// 把 builder 中的数据填充到 mesh 中，并清空。
	public void FillToMeshAndClear(Mesh mesh)
	{
		mesh.Clear(true);

		if (_indices.Count == 0)
		{
			return;
		}

		mesh.vertices = _vertices.ToArray();
		mesh.normals = _normals.ToArray();
		mesh.uv = _texcoords.ToArray();
		mesh.triangles = _indices.ToArray();

		_vertices.Clear();
		_normals.Clear();
		_texcoords.Clear();
		_indices.Clear();
	}

	public void Clear()
	{
		_vertices.Clear();
		_normals.Clear();
		_texcoords.Clear();
		_indices.Clear();
	}
}
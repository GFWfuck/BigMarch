----------------------------------------------------------------------------------------------------
����

һ��������BigMarch BlendTreeӦ�����Ĳ��ֹ��ɣ���ϸ�ڵ���֣��ֱ��ǣ�
1��	StateNode��״̬�ڵ㣬һ��"��Զ��ͣЪ��"״̬�����߲�����Ҫ����ʱ������ָ�����͵����ݡ�
	StateNode�������ӽڵ㡣
	StateNode��Ҫʹ�����Լ����ƣ��̳�Node�ڵ㣬ʵ��GetResult������

2��	AddNode����BlendNode��������֯�����ڵ㡣���ӽڵ�õ�����֮��ǰ�߽�������ӣ����߽����ǻ�ϡ�
	AddNode��BlendNode�������ӽڵ㡣
	AddNode��BlendNode����ʹ��BigMarch�ġ�

3��	BlendTree���������ṩһ��AutoSetup��ť�����ڳ�ʼ����
	BlendTree����ʹ��BigMarch�ġ�

4��	ʹ��BlendTree�Ŀͻ���ͨ��BlendTree�����ã����ø���BlendNode��Weight�����������StateNode����Ϣ��



----------------------------------------------------------------------------------------------------
BlendTreeExample_CameraRig�鿴ָ��

1��	�������ͨ״̬�µ�camera position���л�ϣ����λ�÷ֱ��������״̬�µ�cameraλ�á�����ǰ����������ֹ���������ˡ���������˲����١����������������١���
	���5��StateNode�ֱ��ǣ� StateNode_Back��StateNode_Idle��StateNode_Forward��StateNode_N2oStart��StateNode_N2oStay��
	���ǵĸ��ڵ��ǣ�BlendNode_NormalPositions����ʾnormal״̬�µ�λ�á���

2��	����ͨ״̬�µ�camera position��shake�ڵ���л�ϡ�
	shake�ڵ�ֱ��ǣ�StateNode_NormalHurtShake��StateNode_NormalHitShake��

3��	����ͨ״̬����׼��״̬���л�ϡ�
	�ֱ��ǣ�AddNode_Normal��AddNode_Scope��
	���ڵ��ǣ�BlendNode_Fix����ʾfix״̬�µ�λ�ã�

4��	��������󣬻��л���������תΧ��״̬����״̬��������룬�ƶ������
	��Ͻڵ�ֱ��ǣ�BlendNode_Fix��StateNode_FreeRotation
	���ڵ��ǣ�BlendNode_Root

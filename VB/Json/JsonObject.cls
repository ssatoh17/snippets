VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "JsonObject"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'********************
'JsonObject
'
'JsonParser�ɂ���č쐬���ꂽDictionary���g���₷���������b�p
'********************
  
Private m_keys As New Collection    '���L���Ă���L�[
Private m_data As Dictionary        '���b�v���Ă���f�[�^
Private m_inited As Boolean         '�������ςݔ���
 
Public Property Get JsonKeys() As Collection
    Set JsonKeys = m_keys
End Property
 
Public Property Get Item(ByVal key As String)
Attribute Item.VB_UserMemId = 0
 
    ' "."���܂܂�Ă��邩�ǂ����𒲂ׂ�
    If InStr(key, ".") = 0 Then
        ' "."���܂܂�Ă��Ȃ��ꍇ�͂��̂܂܃L�[�Ƃ��Ďg�p���A�f�[�^��Ԃ�
        If IsObject(m_data(key)) Then
            Set Item = m_data(key)
        Else
            Item = m_data(key)
        End If
    Else
        Dim keys() As String
        Dim i As Long
        Dim tmp
         
        ' �L�[�𕪉�����
        keys = Split(key, ".")
         
        Set tmp = m_data(keys(0))
         
        ' �L�[�����������Ă����A�Ō�Ɏ擾�������������Ԃ�
        For i = 1 To UBound(keys)
            If i = UBound(keys) Then
                If IsObject(tmp(keys(i))) Then
                    Set Item = tmp(keys(i))
                Else
                    Item = tmp(keys(i))
                End If
            Else
                Set tmp = tmp(keys(i))
            End If
        Next
    End If
End Property
 
'********************
'�f�X�g���N�^
'********************
Private Sub Class_Terminate()
  Set m_keys = Nothing
  Set m_data = Nothing
End Sub
  
'********************
'������
'Argument�FJsonParser�Ńp�[�X���I�����Dictionary
'********************
Public Sub Init(ByVal jsonData As Dictionary)
    Dim key As Variant
      
    '��x�ł�Init���Ă΂�Ă����牽�����Ȃ�
    If m_inited Then Exit Sub
      
    For Each key In jsonData.keys
        m_keys.Add (key)
    Next
     
    Set m_data = jsonData
    m_inited = True
      
End Sub
  
'********************
'�L�[���݃`�F�b�N
'Argument�F�`�F�b�N�������L�[
'Return�@�F�����̃L�[�����݂�����True�A���Ȃ����False
'********************
Public Function HasKey(ByVal key As String) As Boolean
  
    Dim keyCache As Variant
      
    For Each keyCache In m_keys
        If key = keyCache Then
            HasKey = True
            Exit Function
        End If
    Next
      
    HasKey = False
End Function
  
'********************
'�z��`�F�b�N
'Argument�F�`�F�b�N�������L�[
'Return�@�F�����̃L�[����擾�ł���Item��Collection�Ȃ�True�A����ȊO�Ȃ�False
'�@�@�@�@�@�܂��A�L�[���̂��̂��Ȃ��ꍇ��False��Ԃ�
'********************
Public Function IsArray(ByVal key As String) As Boolean
    Dim obj As Object
      
    IsArray = False
      
    If Not HasKey(key) Then Exit Function
      
    If TypeName(m_data.Item(key)) = "Collection" Then
        IsArray = True
    End If
      
End Function
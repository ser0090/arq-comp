import PySimpleGUI as sg
from subprocess import check_output, CalledProcessError


main_tab_layout= [
                [sg.Text('Write program')],
                [sg.Input(key='_BIN_FILE_'),sg.FileBrowse(),sg.Button('Write')],
                [sg.Text('',key='_WRITE_RES_')]

]

fetch_tab_layout= [
                    [sg.Text('Fetch Stage Status:')],
                    [sg.Text('',size=(35,10),background_color='white',text_color='blue',key='_FETCH_STAT_')],

                 ]

dec_tab_layout= [
                    [sg.Text('Decode Stage Status:')],
                    [sg.Text('',size=(35,10),background_color='white',text_color='blue',key='_DECODE_STAT_')]
             ]

exec_tab_layout= [
                    [sg.Text('Execution Stage Status:')],
                    [sg.Text('',size=(35,10),background_color='white',text_color='blue', key='_EXEC_STAT_')]
             ]

mem_tab_layout= [
                    [sg.Text('Memory Access Stage Status:')],
                    [sg.Text('',size=(35,10),background_color='white',text_color='blue', key='_MEM_STAT_')],
                    [sg.Text('Data Memory content')],
                    [sg.Text('From: 0x'),sg.Input('00000000',size=(8,1),key='_FROM_ADDR_'),sg.Text('COUNT: '),sg.Input('10',size=(8,1),key='_COUNT_ADDR_')],
                    [sg.Multiline('',size=(35,20),background_color='white',text_color='blue',key='_MEM_DATA_',)]
]
layout = [
            [sg.Input('../bin',key='_BIN_FOLDER_')],
            [sg.TabGroup([
                        [
                            sg.Tab('Main'       , main_tab_layout , tooltip='tip'),
                            sg.Tab('Fetch'      , fetch_tab_layout, tooltip='tip'),
                            sg.Tab('Decode'     , dec_tab_layout  , tooltip='tip'),
                            sg.Tab('Execution'  , exec_tab_layout , tooltip='tip'),
                            sg.Tab('Memory'     , mem_tab_layout  , tooltip='tip'),

                        ]
                        ], tooltip='TIP2')],
            [sg.Button('Refresh'),sg.Button('Step'),sg.Exit()]
          ]


def _write_bin(window,values,device):
    cmd = values['_BIN_FOLDER_'].strip() + '/write ' + device + ' ' + values['_BIN_FILE_'] #TODO: testear conectado al dispositivo
    print(cmd)
    try:
        stat = check_output(cmd, shell=True).strip()
    except CalledProcessError:
        stat = 'ERROR'
    window.Element('_WRITE_RES_').Update(stat)


def _update_fetch(window,values,device):
    cmd = values['_BIN_FOLDER_'].strip() + '/fetch '+ device #TODO: testear conectado al dispositivo
    print (cmd)
    try:
        stat = check_output(cmd, shell=True).strip()
    except CalledProcessError:
        stat = 'ERROR'
    window.Element('_FETCH_STAT_').Update(stat)


def _update_decode(window,values,device):
    cmd = values['_BIN_FOLDER_'].strip() + '/decode ' + device #TODO: testear conectado al dispositivo
    print (cmd)
    try:
        stat = check_output(cmd, shell=True).strip()
    except CalledProcessError:
        stat = 'ERROR'
    window.Element('_DECODE_STAT_').Update(stat)


def _update_exec(window,values,device):
    cmd = values['_BIN_FOLDER_'].strip() +'/exec ' + device #TODO: testear conectado al dispositivo
    print (cmd)
    try:
        stat = check_output(cmd, shell=True).strip()
    except CalledProcessError:
        stat = 'ERROR'
    window.Element('_EXEC_STAT_').Update(stat)


def _update_mem(window,values,device):
    cmd = values['_BIN_FOLDER_'].strip() +'/mem ' + device #TODO: testear conectado al dispositivo
    print (cmd)
    try:
        stat = check_output(cmd, shell=True).strip()
    except CalledProcessError:
        stat = 'ERROR'
    window.Element('_MEM_STAT_').Update(stat)


def _get_mem_data(window,values,device):
    cmd = values['_BIN_FOLDER_'].strip() + '/mem_data ' + device + ' 0x'+values['_FROM_ADDR_']+' '+ values['_COUNT_ADDR_']  # TODO: testear conectado al dispositivo
    print(cmd)
    try:
        stat = check_output(cmd, shell=True).strip()
    except CalledProcessError:
        stat = 'ERROR'
    window.Element('_MEM_STAT_').Update(stat)


def show(device):
    window = sg.Window('Mipd Debugger GUI', layout)
    #device = device.encode('utf-8')
    while True:
        event, values = window.Read()
        print(event, values)
        if event == 'Refresh':
            _update_fetch(window,values,device)
            _update_decode(window,values,device)
            _update_exec(window,values,device)
            _update_mem(window,values,device)
            _get_mem_data(window,values,device)
        elif event == 'Write':
            _write_bin(window,values)

        elif event is None or event == 'Exit':
            break


    window.Close()

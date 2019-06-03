import PySimpleGUI as sg
from subprocess import check_output, CalledProcessError


main_tab_layout= [
                [sg.Text('Write program')],
                [sg.Input(key='_BIN_FILE_'),sg.FileBrowse(),sg.Button('Write')],
                [sg.Text('',key='_WRITE_RES_')],
                [sg.Button('Start')],
                [sg.Text('',key='_START_RES_',size=(50,1))]


]

fetch_tab_layout= [
                    [sg.Text('Fetch Stage Status:')],
                    [sg.Text('',size=(35,10),background_color='white',text_color='blue',key='_FETCH_STAT_')],

                 ]

dec_tab_layout= [
                    [sg.Text('Decode Stage Status:')],
                    [sg.Text('',size=(35,40),background_color='white',text_color='blue',key='_DECODE_STAT_')]
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
            [sg.Text('BIN_PATH:'),sg.Input('',key='_BIN_FOLDER_',size=(70,1))],
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
    window.Element('_MEM_DATA_').Update(stat)

def _step(window,values,device):
    cmd = values['_BIN_FOLDER_'].strip() + '/step ' + device
    print(cmd)
    try:
        stat = check_output(cmd, shell=True).strip()
    except CalledProcessError:
        stat = 'ERROR'
    window.Element('_WRITE_RES_').Update(stat)

def _start(window,values,device):
    cmd = values['_BIN_FOLDER_'].strip() + '/start ' + device
    print(cmd)
    try:
        stat = check_output(cmd, shell=True).strip()
    except CalledProcessError:
        stat = 'ERROR'
    window.Element('_START_RES_').Update(stat)

def _refresh(window,values,device):
    _update_fetch(window,values,device)
    _update_decode(window,values,device)
    _update_exec(window,values,device)
    _update_mem(window,values,device)
    _get_mem_data(window,values,device)

def show(device,binfolder):
    window = sg.Window('Mipd Debugger GUI', layout)
    window.Element('_BIN_FOLDER_').Update(binfolder)
    #device = device.encode('utf-8')
    while True:
        event, values = window.Read()
        #print(event, values)
        if event == 'Refresh':
            _refresh(window,values,device)
        elif event == 'Write':
            _write_bin(window,values,device)
        elif event == 'Step':
            _step(window,values,device)
            _refresh(window,values,device)
        elif event == 'Start':
            _start(window,values,device)
            _refresh(window,values,device)
        elif event is None or event == 'Exit':
            break


    window.Close()

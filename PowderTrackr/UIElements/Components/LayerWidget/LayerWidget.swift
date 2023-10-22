import SwiftUI

struct LayerWidget: View {
    private enum Layout {
        static let buttonGeometry = "Button"
        static let stackGeometry = "VStack"
    }

    @Namespace var animation

    @Binding var isOpen: Bool

    @Binding var mapMenuState: MapView.MapMenuState
    @Binding var selectedRace: Race?
    let startAction: () -> Void
    let pauseAction: () -> Void
    let stopAction: () -> Void
    let resumeAction: () -> Void
    let raceAction: (Bool) -> Void
    let raceTrackAction: () -> Void

    var body: some View {
        if isOpen {
            openState
        } else {
            closeState
        }
    }

    var openState: some View {
        HStack {
            Spacer()
            HStack {
                switch mapMenuState {
                case .raceMarkerOpened:
                    if let race = selectedRace {
                        Text(race.name)
                            .frame(height: 64)
                            .font(.subheadline)
                            .bold()
                            .padding([.leading, .trailing], 24)
                            .frame(minHeight: 40)
                            .foregroundColor(.teal)
                            .background(.white)
                            .cornerRadius(20)
                            .customShadow()
                        Button {
                        } label: {
                            Text("Start race")
                                .frame(height: 64)
                        }
                        .buttonStyle(SkiingButtonStyle(style: .secondary))
                    }
                case .paused:
                    Button {
                        resumeAction()
                        isOpen.toggle()
                    } label: {
                        Text("Resume")
                            .frame(height: 64)
                    }
                    .buttonStyle(SkiingButtonStyle(style: .secondary))

                    Button {
                        stopAction()
                        isOpen.toggle()
                    } label: {
                        Text("Stop")
                            .frame(height: 64)
                    }
                    .buttonStyle(SkiingButtonStyle(style: .secondary))
                case .on:
                    Button {
                        pauseAction()
                        isOpen.toggle()
                    } label: {
                        Text("Pause")
                            .frame(height: 64)
                    }
                    .buttonStyle(SkiingButtonStyle(style: .secondary))
                    Button {
                        stopAction()
                        isOpen.toggle()
                    } label: {
                        Text("Stop")
                            .frame(height: 64)
                    }
                    .buttonStyle(SkiingButtonStyle(style: .secondary))
                case .off:
                    Spacer()
                    Button {
                        raceAction(false)
                    } label: {
                        Text("Add Race")
                            .frame(height: 64)
                    }
                    .buttonStyle(SkiingButtonStyle(style: .secondary))
                    Button {
                        startAction()
                        isOpen.toggle()
                    } label: {
                        Text("Start Tracking")
                            .frame(height: 64)
                    }
                    .buttonStyle(SkiingButtonStyle(style: .secondary))
                case .raceCreation, .markersPlaced:
                    Button {
                        raceAction(false)
                        isOpen.toggle()
                    } label: {
                        Image(systemName: "checkmark")
                            .frame(height: 64)
                    }
                    .buttonStyle(SkiingButtonStyle(style: .secondary))
                    .disabled(mapMenuState != .markersPlaced)
                    Button {
                        withAnimation {
                            raceAction(true)
                            isOpen.toggle()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .frame(height: 64)
                    }
                    .buttonStyle(SkiingButtonStyle(style: .secondary))
                }
            }
            LayerWidgetButton(isOpen: $isOpen)
                .background(.teal)
                .cornerRadius(16)
                .matchedGeometryEffect(id: Layout.buttonGeometry, in: animation)
        }
        .background(background)
        .padding()
    }

    var closeState: some View {
        HStack {
            Spacer()
            VStack {
                LayerWidgetButton(isOpen: $isOpen)
                    .matchedGeometryEffect(id: Layout.buttonGeometry, in: animation)
            }
            .background(background)
            .padding()
        }
    }

    var background: some View {
        RoundedRectangle(cornerRadius: 16)
            .foregroundColor(isOpen ? .clear : .teal)
            .cornerRadius(16)
            .shadow(radius: 4, x: .zero, y: 4)
            .matchedGeometryEffect(id: Layout.stackGeometry, in: animation)
    }
}
